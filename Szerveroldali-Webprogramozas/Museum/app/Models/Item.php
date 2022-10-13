<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Item extends Model
{
    use HasFactory;

    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'name',
        'description',
        'image',
    ];

    /**
     * The attributes that should be cast.
     *
     * @var array<string, string>
     */
    protected $casts = [
        'obtained' => 'datetime',
    ];

    public function labeled()
    {
        return $this->belongsToMany(Label::class)
            ->withPivot('is_labeled')
            ->wherePivot('is_labeled', 1);
    }

    public function notLabeled()
    {
        return $this->belongsToMany(Label::class)
            ->withPivot('is_labeled')
            ->wherePivot('is_labeled', 0);
    }

    public function comments()
    {
        return $this->hasMany(Comment::class);
    }

    public function labels()
    {
        return $this->belongsToMany(Label::class);
    }
}
