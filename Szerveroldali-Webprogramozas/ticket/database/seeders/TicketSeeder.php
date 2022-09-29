<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use App\Models\Ticket;
use App\Models\User;

class TicketSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        $users = User::all();

        foreach ($users as $submitter) {
            $tmpUsers = $users->where('id', '!=', $submitter->id)->random(5);
            Ticket::factory()->hasAttached($submitter, ['is_submitter' => true, 'is_responsible' => true])->hasAttached($tmpUsers, ['is_submitter' => false, 'is_responsible' => false])->create();
        }
    }
}
