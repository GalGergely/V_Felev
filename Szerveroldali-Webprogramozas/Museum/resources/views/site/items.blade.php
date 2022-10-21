@extends('layouts.layout')

@section('title', 'Items')

@section('content')
<h1 class="ps-3">Items</h1>
<hr />
<div class="table-responsive">
    <table class="table align-middle table-hover">
        <thead class="text-center table-light">
            <tr>
                <th style="width: 10%">Name</th>
                <th style="width: 20%">Description</th>
                <th style="width: 40%">Date of acquisition</th>
                <th style="width: 30%">Image</th>
            </tr>
        </thead>
        <tbody class="text-center">
            @foreach ($items as $item)
            <tr class="table-warning" onclick="window.open('{{route('items')}}')";>
                <td>
                    <span class="badge rounded-pill bg-info fs-6">{{$item->name}}</span>
                </td>
                <td>
                    <div>{{ $item->description }}</div>
                </td>
                <td>
                    <div>{{$item->obtained}}</div>
                </td>
                <td>
                    <img src="https://www.w3schools.com/images/w3schools_green.jpg" alt="W3Schools.com">
                </td>
            </tr>
        @endforeach

@endsection
