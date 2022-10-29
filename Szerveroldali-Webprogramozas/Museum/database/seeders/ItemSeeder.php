<?php

namespace Database\Seeders;

use App\Models\Item;
use App\Models\User;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class ItemSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        $arr = ['The Seated Scribe', 'Vedus de Milo', 'Winged Victory of Sanithrace', 'Apollo of Piombino', 'Diana of Versailles', 'Dying Slave', 'Apollo Sauroctonos', 'Marcellus as Hermes Logios', 'Ship of fools', 'Death of the Virgin', 'The fortune teller'];
        for ($i = 0; $i < 11; $i++) {
            Item::factory()->create([
                'name' => $arr[$i],
            ]);
        }
    }
}
