<?php

namespace Database\Seeders;

use App\Models\Comment;
use App\Models\Item;
use App\Models\User;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class CommentSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        $items = Item::all();
        foreach ($items as $item) {
            $users = User::all()->random(3);
            foreach ($users as $user) {
                Comment::factory()
                    ->for($item)
                    ->create(['user_id' => $user->id]);
            }
        }
    }
}
