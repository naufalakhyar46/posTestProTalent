<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Cart extends Model
{
    use HasFactory;
    protected $table = 'carts';
    protected $dates = ['created_at', 'updated_at'];
    protected $guarded = [];

    public function product(){
        return $this->belongsTo(Product::class,'product_id','id');
    }
}
