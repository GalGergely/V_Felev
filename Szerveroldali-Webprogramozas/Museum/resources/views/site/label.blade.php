@extends('layouts.layout')

@section('title','$label->name')

@section('content')
<div class="container-fluid px-5 my-3">
    <div class="d-flex">
        <h1 class="ps-3 me-auto">{{$label->name}}
            @auth
            @if (Auth::user()->is_admin)
            <span class="badge bg-danger">
            <a href="{{ route('labels.edit', ['label' => $label->id]) }}" class="btn btn-primary mx-1" data-bs-toggle="tooltip" data-bs-placement="bottom" title="Szerkesztés">
                <i class="fa-solid fa-pen-to-square fa-fw fa-xl"></i>
            </a>
            <form action="{{ route('labels.destroy', ['label' => $label->id ]) }}" method="post">
                @csrf
                @method('delete')
                <button class="btn btn-danger mx-1" data-bs-toggle="tooltip" data-bs-placement="bottom" title="Törlés" type="submit">
                    <i class="fa-solid fa-trash fa-fw fa-xl"></i>
                </button>
            </form>
            @endif
            @endauth
    </div>
    <hr />
    <div class="container-fluid px-5 my-3">
        <div class="d-flex">
            <h2>Items with this label:<br></h2>
        </div>
        <div class="d-flex">
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
            @foreach ($label->items as $item)
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
                                <img src="https://www.w3schools.com/images/w3schools_green.jpg" alt="W3Schools.com">
                            </td>
                        </tr>
            @endforeach
        </table>
        </div>
    </div>
@endsection
