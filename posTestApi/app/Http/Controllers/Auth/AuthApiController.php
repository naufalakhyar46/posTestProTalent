<?php

namespace App\Http\Controllers\Auth;

use App\Models\User;
use Illuminate\Http\Request;
use Tymon\JWTAuth\Facades\JWTAuth;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Session;
use Illuminate\Support\Facades\Validator;
use Tymon\JWTAuth\Exceptions\JWTException;
use Tymon\JWTAuth\Exceptions\TokenExpiredException;
use Tymon\JWTAuth\Exceptions\TokenInvalidException;

class AuthApiController extends Controller
{
    public function me(Request $request)
    {
        $arr = [
            'user'=>auth()->user()
        ];
        return success($arr,'Get data successfully');
    }

    public function login(Request $request){
        $username = $request->username;
        $password = $request->password;
        $remember = !empty($request->remember) ? true : false;
        $user =  User::where('username',$username)->first();
        if($user){
            if(Hash::check($password, $user->password)){
                $token = auth()->attempt(['username'=>$username,'password'=>$password]);
                if($token){
                    Auth::login($user, $remember);
                    $arr = [
                        'user'=>$user,
                        'token'=>$token
                    ];
                    return success($arr,'Login successfully');
                }else{
                    return errorRespApi('Username or password not suitable');
                }
            }else{
                return errorRespApi('Password wrong');
            }
        }else{
            return errorRespApi('Username not found');
        }
    }

    public function register(Request $request){
        $rules = [
            'name' => 'min:3|required|string',
            'username' => 'min:3|required|unique:users,username',
            'email' => 'required|email|unique:users,email',
            'password'=> 'required|min:6|confirmed'
        ];
        
        $validator = Validator::make($request->all(), $rules);
        if ($validator->fails()) {
            return errorForm($validator->errors()->first());
        }

        $user = new User;
        $user->name = $request->name;
        $user->username = $request->username;
        $user->email = $request->email;
        $user->password = bcrypt($request->password);
        $user->role = 2;
        $user->save();
        
        $arr = [
            'user'=>$user
        ];

        return success($arr,'Data user added successfully');
    }

    public function checkPassword(Request $request){
        if(Hash::check($request->password, auth()->user()->password)){
            return successMessage('Password same');
        }else{
            return errorRespApi('Password wrong');
        }
    }

    public function changePassword(Request $request){
        $user = User::firstWhere('id',auth()->user()->id);
        $rules = [
            'password'=> 'required|min:6|confirmed'
        ];

        $validator = Validator::make($request->all(), $rules);
        if ($validator->fails()) {
            return errorForm($validator->errors()->first());
        }
        $user->password = bcrypt($request->password);
        $user->save();
        return successMessage('Password updated successfully');
    }

    public function logout(){
        if(!empty(JWTAuth::getToken())){
            $removeToken = JWTAuth::invalidate(JWTAuth::getToken());
            if($removeToken) {
                return successMessage('Logout successfully');
            }else{
                return errorRespApi('Token is invalid');
            }
        }else{
            return errorRespApi('Token is null');
        }
    }
}
