<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Emplacement extends Model
{
    use HasFactory;

    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'libelle',
        'image_path',
    ];

    public $timestamps = false;

    public function types(){
        return $this->belongsToMany(Type::class);
    }

    public function items(){
        return $this->belongsToMany(Item::class);
    }
}
