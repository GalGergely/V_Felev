<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;
use App\Models\User;

class UserSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        for ($i = 0; $i < 20; $i++) {
            User::factory()->create([
                'name' => 'User' . strval($i),
                'email' => 'user' . strval($i) . '@szerveroldali.hu',
                'is_admin' => false,
            ]);
        }
        User::factory()->create([
            'name' => 'Admin',
            'email' => 'admin@szerveroldali.hu',
            'password' => Hash::make('adminpwd'),
            'is_admin' => true,
        ]);
        //User::factory(10)->create();
    }
}
