<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Order\OrderApiController;
use App\Http\Controllers\Product\ProductApiController;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

Route::post('login', 'App\Http\Controllers\Auth\AuthApiController@login')->name('api.auth.login');
Route::post('register', 'App\Http\Controllers\Auth\AuthApiController@register')->name('api.auth.register');
Route::get('logout', 'App\Http\Controllers\Auth\AuthApiController@logout')->name('api.auth.logout');
Route::group(['middleware' => ['jwt.verify']], function () {
    Route::get('get-summary', 'App\Http\Controllers\Order\OrderApiController@getSummaryCard')->name('api.summary');
    Route::get('me', 'App\Http\Controllers\Auth\AuthApiController@me')->name('api.auth.me');
    Route::post('check-password', 'App\Http\Controllers\Auth\AuthApiController@checkPassword')->name('api.auth.check-password');
    Route::post('change-password', 'App\Http\Controllers\Auth\AuthApiController@changePassword')->name('api.auth.change-password');
    Route::group(['prefix' => 'user'], function () {
        Route::get('/', 'App\Http\Controllers\User\UserApiController@index')->name('api.user.index');
        Route::get('show/{user}', 'App\Http\Controllers\User\UserApiController@show')->name('api.user.show');
        Route::get('default-password/{user}', 'App\Http\Controllers\User\UserApiController@setDefaultPassword')->name('api.user.setDefaultPassword');
        Route::post('/', 'App\Http\Controllers\User\UserApiController@store')->name('api.user.store');
        Route::post('{id}', 'App\Http\Controllers\User\UserApiController@update')->name('api.user.update');
        Route::delete('{id}', 'App\Http\Controllers\User\UserApiController@destroy')->name('api.user.destroy');
    });
    Route::group(['prefix' => 'product'], function () {
        Route::get('/', [ProductApiController::class, 'index']);
        Route::post('/', [ProductApiController::class, 'store']);
        Route::get('/{id}', [ProductApiController::class, 'show']);
        Route::post('/{id}', [ProductApiController::class, 'update']);
        Route::delete('/{id}', [ProductApiController::class, 'destroy']);
    });
    Route::group(['prefix' => 'cart'], function () {
        Route::get('/', [OrderApiController::class, 'listCart']);
        Route::post('/', [OrderApiController::class, 'addToCart']);
        Route::delete('{id}', [OrderApiController::class, 'destroyCart']);
    });
    Route::group(['prefix' => 'order'], function () {
        Route::get('/', [OrderApiController::class, 'index']);
        Route::post('/', [OrderApiController::class, 'checkout']);
        Route::get('/{id}', [OrderApiController::class, 'show']);
        Route::get('/{id}/paid', [OrderApiController::class, 'paid']);
        Route::get('/{id}/cancel', [OrderApiController::class, 'paidCancel']);
    });
});

