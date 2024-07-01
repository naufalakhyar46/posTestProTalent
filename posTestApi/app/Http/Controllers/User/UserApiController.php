<?php

namespace App\Http\Controllers\User;

use Exception;
use App\Models\User;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;

class UserApiController extends Controller
{
    public function index(Request $request){
        $currentPage = $request->current_page;
        $pageSize = $request->page_size;
        $maxPages = !empty($request->max_page) ?? 0;
        $lastData = false;
        // $pageSize = 5;
        // $maxPages = 6;
        
        $query = new User;

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

    public function show($user){
        $user = User::where('id',$user)->first();
        return success($user);
    }

    public function store(Request $request){
            $rules = [
                'name' => 'min:3|required|string',
                'username' => 'min:3|required|unique:users,username',
                'email' => 'required|email|unique:users,email',
                'image' => 'mimes:jpeg,jpg,png,webp|max:2000',
            ];
            
            $validator = Validator::make($request->all(), $rules);
            if ($validator->fails()) {
                return errorForm($validator->errors()->first());
            }

            $user = new User;
            if($request->image != 'undefined' && !empty($request->image)){
                $path_img = 'image/user/';
                $fileName = 'img_'.time().'.'.$request->image->getClientOriginalExtension();
                $request->image->move($path_img, $fileName);
                $user->image = $fileName;
            }

            $user->name = $request->name;
            $user->username = $request->username;
            $user->email = $request->email;
            $user->role = !empty($request->role) ? $request->role : 2;
            $user->password = Hash::make('testapp123');
            $user->save();
            
            return successAdd('user');
    }

    public function update(Request $request,$id){
            $user = User::where('id',$id)->first();
            $rules = [
                'name' => 'min:3|required|string',
                'username' => 'min:3|required|unique:users,username,'.$user->id,
                'email' => 'required|email|unique:users,email,'.$user->id,
                'image' => 'mimes:jpeg,jpg,png,webp|max:2000',
            ];

            $validator = Validator::make($request->all(), $rules);
            if ($validator->fails()) {
                return errorForm($validator->errors()->first());
            }
            if($request->image != 'undefined' && !empty($request->image)){
                $path_img = 'image/user/';
                if($user->image != null){
                    if(file_exists(public_path().'/'.$path_img.$user->image)){
                        unlink($path_img.$user->image);
                    }
                }
                $fileName = 'img_'.time().'.'.$request->image->getClientOriginalExtension();
                $request->image->move($path_img, $fileName);
                $user->image = $fileName;
            }
            $user->name = $request->name;
            $user->username = $request->username;
            $user->role = empty($request->role) ? $user->role : $request->role;
            $user->email = $request->email;
            $user->save();

            return successUpdate('user');
    }

    public function setDefaultPassword(User $user){
            $user->password = Hash::make('testapp123');
            $user->save();
            return successUpdate('user');
    }

    public function destroy($id){
        $user = User::find($id);
        $path_img = 'image/user/';
        if(!empty($user->image)){
            if(file_exists(public_path().'/'.$path_img.$user->image)){
                unlink($path_img.$user->image);
            }
        }
        $user->delete();
        return successDelete('user');
    }
}
