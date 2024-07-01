<?php

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Order extends Model
{
    use HasFactory;
    protected $appends = ['created_date','dolarprice'];
    protected $table = 'orders';
    protected $dates = ['created_at', 'updated_at','end_paid'];
    protected $guarded = [];

    public function user(){
        return $this->belongsTo(User::class,'user_id','id');
    }

    public function orderDetail(){
        return $this->hasMany(DetailOrder::class,'order_id','id');
    }

    public function getCreatedDateAttribute(){
        return $this->created_at->isoFormat('DD, MMMM YYYY HH:mm'); 
    }

    public function getDolarpriceAttribute(){
        return "$".number_format($this->total_price, 2,'.', ',');
    }

}
