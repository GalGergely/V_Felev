<?php

namespace Database\Seeders;

use App\Models\Item;
use App\Models\Label;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Arr;

class LabelSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        $items = Item::all();
        for ($i = 0; $i < 9; $i++) {
            $arr = ['nice', 'awsome', 'beautiful', 'agonizing', 'lively', 'anbitious', 'elegant', 'honest', 'impolite'];
            $tmpItems = $items->random(5);
            Label::factory()->hasAttached($tmpItems, ['is_labeled' => true])->create([
                'name' => $arr[$i],
            ]);
        }
    }
}
