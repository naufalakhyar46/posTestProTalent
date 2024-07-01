<?php

namespace App\Http\Controllers\Order;

use stdClass;
use Carbon\Carbon;
use App\Models\Cart;
use App\Models\Order;
use App\Models\Product;
use App\Models\DetailOrder;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Http\Controllers\Controller;

class OrderApiController extends Controller
{
    public function getSummaryCard(){
        $arr = new stdClass();
        $arr2 = new stdClass();
        $arr3 = new stdClass();

        $arr->color = 'Sales today';
        $arr->label = 'Sales today';
        $arr->value = count(Order::whereDate('created_at',Carbon::now())->pluck('id')->toArray());
        $arr->value2 = '$'.number_format(Order::select('id','total_price')->whereDate('created_at',Carbon::now())->sum('total_price'), 2,'.', ',');

        $arr2->label = 'Sale 7 Days Ago';
        $arr2->value = count(Order::whereBetween('created_at',[Carbon::now()->subDays(7), Carbon::now()])->pluck('id')->toArray());
        $arr2->value2 = '$'.number_format(Order::select('id','total_price')->whereBetween('created_at',[Carbon::now()->subDays(7), Carbon::now()])->sum('total_price'), 2,'.', ',');

        $arr3->label = 'Total Product';
        $arr3->value = count(Product::pluck('id')->toArray());
        $arr3->value2 = count(Order::where('product_status','paid')->pluck('id')->toArray());;

        $dtArr[0] = $arr;
        $dtArr[1] = $arr2;
        $dtArr[2] = $arr3;

        return success($dtArr);
    }

    public function getOrderCode(){
        $order = count(Order::whereDate('created_at', Carbon::today())->pluck('id')->toArray());
        if($order > 0){
            $order = 1;
        }else{
            $order +=1;
        }
        $code = 'ORD'.date('dmY').sprintf("%04d", $order);
        return $code;
    }

    public function addToCart(Request $request){
        $checkCart = Cart::where([['user_id',auth()->user()->id],['product_id',$request->product_id]])->first();
        if($checkCart){
            $checkCart->qty = $checkCart->qty + 1;
            $checkCart->save();
        }else{
            $cart = new Cart;
            $cart->user_id = auth()->user()->id;
            $cart->product_id = $request->product_id;
            $cart->qty = 1;
            $cart->save();
        }
        return successMessage('The product has been successfully added to the basket');
    }

    public function destroyCart($id){
        $query = Cart::firstWhere('id',$id);
        $query->delete();
        return successDelete('cart');
    }

    public function listCart(){
        $query = Cart::with('product')->orderBy('created_at','desc')->where('user_id',auth()->user()->id)->get();
        return success($query);
    }

    public function index(Request $request){
        $currentPage = $request->current_page;
        $pageSize = $request->page_size;
        $maxPages = !empty($request->max_page) ?? 0;
        $lastData = false;
        // $pageSize = 5;
        // $maxPages = 6;
        
        $query = Order::with('user:id,name,image,role')->with(['orderDetail','orderDetail.product'])->withCount(['orderDetail']);

        if(!empty($request->val_search)){
            $query->where('product_status',$request->val_search);
        }

        $totalItems = count($query->pluck('id')->toArray());
        // $totalItems = 500;
        $totalPages = ceil($totalItems / $pageSize);

        if ($currentPage < 1) {
            $currentPage = 1;
        } else if ($currentPage > $totalPages) {
            $currentPage = $totalPages;
            $lastData = true;
        }

        if ($totalPages <= $maxPages) {
            $startPage = 1;
            $endPage = $totalPages;
        } else {
            $maxPagesBeforeCurrentPage = floor($maxPages / 2);
            $maxPagesAfterCurrentPage = ceil($maxPages / 2) - 1;
            if ($currentPage <= $maxPagesBeforeCurrentPage) {
                $startPage = 1;
                $endPage = $maxPages;
            } else if ($currentPage + $maxPagesAfterCurrentPage >= $totalPages) {
                $startPage = $totalPages - $maxPages + 1;
                $endPage = $totalPages;
            } else {
                $startPage = $currentPage - $maxPagesBeforeCurrentPage;
                $endPage = $currentPage + $maxPagesAfterCurrentPage;
            }
        }

        $startIndex = ($currentPage - 1) * $pageSize;
        $endIndex = min($startIndex + $pageSize - 1, $totalItems - 1);
        $pages = [];

        for($i=$startPage;$i<$endPage+1;$i++){
            $pages[] = $i;
        }

        $query = $query->skip($startIndex)->take($pageSize);
        $query = $query->orderBy('created_at','desc')->get();
        
        if($lastData){
            $query = [];
        }

        return success([
            'totalItems'=> $totalItems,
            'currentPage'=> $currentPage,
            'pageSize'=> $pageSize,
            'totalPages'=> $totalPages,
            'startPage'=> $startPage,
            'endPage'=> $endPage,
            'startIndex'=> $startIndex,
            'endIndex'=> $endIndex,
            'pages'=> $pages,
            'query'=>$query
        ]);
    }

    public function checkout(Request $request){
        $order = new Order;
        $order->user_id = auth()->user()->id;
        $order->order_code = $this->getOrderCode();
        $order->customer_name = $request->customer_name;
        $order->total_price = $request->total_price;
        $order->product_status = 'unpaid';
        $order->end_paid = Carbon::now()->addHour(1);
        $order->save();

        foreach($request->order_detail as $row){
            $detailOrder = new DetailOrder;
            $detailOrder->order_id = $order->id;
            $detailOrder->product_id = $row['product_id'];
            $detailOrder->product_name = $row['product_name'];
            $detailOrder->qty = $row['qty'];
            $detailOrder->price = $row['price'];
            $detailOrder->per_total_price = $row['per_total_price'];
            $detailOrder->product_status = $order->product_status;
            $detailOrder->save();
        }
        $cart = Cart::where('user_id',auth()->user()->id)->delete();
        $query = Order::where('id',$order->id)->with('user:id,name,image,role')->with(['orderDetail','orderDetail.product'])->withCount(['orderDetail'])->first();
        return success($query,'Checkout successfully');
    }

    public function show($id){
        $query = Order::where('id',$id)->with('user:id,name,image,role')->with(['orderDetail','orderDetail.product'])->withCount(['orderDetail'])->first();
        if(!$query){
            return errorRespApi('Order not found');
        }
        $query->paidsum = $query->orderDetail()->sum('per_total_price');
        return success($query);
    }
    
    public function paid($id){
        $query = Order::where('id',$id)->with('user:id,name,image,role')->with(['orderDetail','orderDetail.product'])->withCount(['orderDetail'])->first();
        $query->product_status = 'paid';
        $query->save();
        $detail = DetailOrder::where('order_id',$query->id);
        foreach($detail->get() as $row){
            $row->product_status = $query->product_status;
            $row->save();
        }
        return success($query,'Order paid successfully');
    }

    public function paidCancel($id){
        $query = Order::where('id',$id)->with('user:id,name,image,role')->with(['orderDetail','orderDetail.product'])->withCount(['orderDetail'])->first();
        $query->product_status = 'cancel';
        $query->save();
        $detail = DetailOrder::where('order_id',$query->id);
        foreach($detail->get() as $row){
            $row->product_status = $query->product_status;
            $row->save();
        }
        return success($query,'Order cancelled');
    }
}
