<?php

namespace App\Models;

// use Illuminate\Contracts\Auth\MustVerifyEmail;
use Tymon\JWTAuth\Contracts\JWTSubject;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable implements JWTSubject
{
    use HasFactory, Notifiable;

    protected $appends = ['imagepath'];
    protected $fillable = [
        'name',
        'username',
        'email',
        'image',
        'role',
        'password',
    ];

    protected $hidden = [
        'password',
        'remember_token',
    ];

    protected $casts = [
        'email_verified_at' => 'datetime',
    ];

    protected $dates = ['created_at', 'updated_at'];

    public function getJWTIdentifier()
    {
        return $this->getKey();
    }

    public function getJWTCustomClaims()
    {
        return [];
    }

    public function getImagepathAttribute(){
        if(empty($this->image)){
            $colors = [
                'ab60b8', 'ef6c00', '23b6c9', '172568',
                '303e45', '2196f3', '37475d', '1354b0',
                'b2bf2d', '394aa5', '00b098', 'eb673e',
                '1e87da', '714dad', '515ea8', 'de5b87',
                '1b8ccf', '5b5bc3',
            ];
            $rk = array_rand($colors,1);
            $value = 'https://ui-avatars.com/api/?name='.$this->name.'&length=3&color=FFFFFF&bold=true&background='.$colors[$rk];
        }else{
            $value = url('image/user',$this->image);
        }
        return $value; 
    }
}
