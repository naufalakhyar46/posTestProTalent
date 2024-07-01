<?php

namespace App\Http\Controllers\Product;

use App\Models\Product;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Validator;

class ProductApiController extends Controller
{
    public function index(Request $request){
        $currentPage = $request->current_page;
        $pageSize = $request->page_size;
        $maxPages = !empty($request->max_page) ?? 0;
        $lastData = false;
        // $pageSize = 5;
        // $maxPages = 6;
        
        $query = Product::with('user:id,name,image,role')->withCount(['orderDetail'=>function($q){return $q->where('product_status','paid');}]);

        if(!empty($request->val_search)){
            $query->where('category',$request->val_search);
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

    public function show($id){
        $query = Product::where('id',$id)->withCount(['orderDetail'=>function($q){return $q->where('product_status','paid');}])->first();
        if(!$query){
            return errorRespApi('Product not found');
        }
        return success($query);
    }

    public function store(Request $request){
        $rules = [
            'product_name' => 'required',
            'category' => 'required',
            'price' => 'required',
            'image' => 'required|mimes:jpeg,jpg,png,webp|max:2000',
        ];
        
        $validator = Validator::make($request->all(), $rules);
        if ($validator->fails()) {
            return errorForm($validator->errors()->first());
        }
        $query = new Product;
        if($request->image != 'undefined' && !empty($request->image)){
            $path_img = 'image/product/';
            $fileName = 'img_'.time().'.'.$request->image->getClientOriginalExtension();
            $request->image->move($path_img, $fileName);
            $query->image = $fileName;
        }
        
        $query->user_id = auth()->user()->id;
        $query->product_name = $request->product_name;
        $query->description = $request->description;
        $query->category = $request->category;
        $query->price = $request->price;
        $query->save();
        
        return successAdd('product');
    }
    
    public function update(Request $request, $id){
        $query = Product::firstWhere('id',$id);
        if(!$query){
            return errorRespApi('Product not found');
        }

        $rules = [
            'product_name' => 'required',
            'category' => 'required',
            'price' => 'required',
            'image' => 'mimes:jpeg,jpg,png,webp|max:2000',
        ];
        $validator = Validator::make($request->all(), $rules);
        if ($validator->fails()) {
            return errorForm($validator->errors()->first());
        }

        if($request->image != 'undefined' && !empty($request->image)){
            $path_img = 'image/product/';
            if($query->image != null){
                if(file_exists(public_path().'/'.$path_img.$query->image)){
                    unlink($path_img.$query->image);
                }
            }
            $fileName = 'img_'.time().'.'.$request->image->getClientOriginalExtension();
            $request->image->move($path_img, $fileName);
            $query->image = $fileName;
        }

        $query->user_id = auth()->user()->id;
        $query->product_name = $request->product_name;
        $query->description = $request->description;
        $query->category = $request->category;
        $query->price = $request->price;
        $query->save();
        
        return successUpdate('product');
    }

    public function destroy($id){
        $query = Product::firstWhere('id',$id);
        $path_img = 'image/product/';
        if(!$query){
            return errorRespApi('Product not found');
        }
        if($query->image != null){
            if(file_exists(public_path().'/'.$path_img.$query->image)){
                unlink($path_img.$query->image);
            }
        }
        $query->delete();
        return successDelete('product');
    }
}
