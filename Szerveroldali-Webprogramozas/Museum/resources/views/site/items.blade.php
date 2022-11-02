@extends('layouts.layout')

@section('title', 'Items')

@section('content')
<h1 class="ps-3">Items</h1>
<hr />
<div class="table-responsive">
    <table class="table align-middle table-hover">
        <thead class="text-center table-light">
            <tr>
                <th style="width: 30%">Name</th>
                <th style="width: 20%">Description</th>
                <th style="width: 20%">Date of acquisition</th>
                <th style="width: 30%">Image</th>
            </tr>
        </thead>
        <tbody class="text-center">
            @foreach ($items as $item)
            <tr class="table-warning" onclick="location.href='{{route('items.show', ['item' => $item->id])}}'";>
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
                    <img height=100 src="{{ asset($item->image ? 'storage/' . $item->image : 'images/favicon.png') }}">
                </td>
            </tr>
        @endforeach
        {{ $items->links() }}
@endsection
