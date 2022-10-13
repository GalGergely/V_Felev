<?php

namespace Database\Seeders;

use App\Models\Item;
use App\Models\Label;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

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

        foreach ($items as $item) {
            $tmpItems = $items->random(5);
            //Label::factory()->hasAttached($item, ['is_labeled' => true])->hasAttached($tmpItems, ['is_labeled' => false])->create();
            Label::factory()->hasAttached($tmpItems, ['is_labeled' => true])->create();
        }
    }
}
