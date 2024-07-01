<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Product extends Model
{
    use HasFactory;
    protected $appends = ['imagepath','dolarprice'];
    protected $table = 'products';
    protected $dates = ['created_at', 'updated_at'];
    protected $guarded = [];

    public function user(){
        return $this->belongsTo(User::class,'user_id','id');
    }

    public function orderDetail(){
        return $this->hasMany(DetailOrder::class,'product_id','id');
    }

    public function getImagepathAttribute(){
        return url('image/product',$this->image); 
    }

    public function getDolarpriceAttribute(){
        return "$".number_format($this->price, 2,'.', ',');
    }
}
