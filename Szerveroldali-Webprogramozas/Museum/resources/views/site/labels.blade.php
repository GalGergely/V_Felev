@extends('layouts.layout')

@section('title', 'Labels')

@section('content')
<h1 class="ps-3">Labels</h1>
<hr />
<div class="table-responsive">
        @if (Session::has('label_created'))
            <div class="alert alert-success" role="alert">
                New label "{{ Session::get('label_created') }}" has been successfuly created.
            </div>
        @endif
        @if (Session::has('label_updated'))
            <div class="alert alert-success" role="alert">
                Label "{{ Session::get('label_updated') }}" has been successfuly updated.
            </div>
        @endif
        @if (Session::has('label_deleted'))
            <div class="alert alert-success" role="alert">
                Label "{{ Session::get('label_deleted') }}" has been successfuly deleted.
            </div>
        @endif
    <table class="table align-middle table-hover">
        <thead class="text-center table-light">
            <tr>
                <th style="width: 100%">Name</th>
            </tr>
        </thead>
        <tbody class="text-center">
            @foreach ($labels as $label)
                @if ($label->display=='1')
                <tr class="table-warning" onclick="location.href='{{route('labels.show', ['label' => $label->id])}}'";>
                     <td>
                        <span class="badge rounded-pill fs-6" style="background-color: {{$label->color}}">{{$label->name}}</span>
                    </td>
                </tr>
                @endif
            @endforeach
            @auth
            @if (Auth::user()->is_admin)
            @foreach ($labels as $label)
                @if ($label->display=='0')
                <tr class="table-danger" onclick="location.href='{{route('labels.show', ['label' => $label->id])}}'";>
                     <td>
                        <span class="badge rounded-pill fs-6" style="background-color: {{$label->color}}">{{$label->name}}</span>
                    </td>
                </tr>
                @endif
            @endforeach
            @endif
            @endauth
@endsection
