@extends('layouts.layout')

@section('title','Edit Comment')

@section('content')
<h2>Edit your comment</h2>
<form action="{{ isset($comment) ? route('items.updateComment', ['comment' => $comment->id]) : ''}}" method="post">
    @csrf
    <div class="mb-3">
        <textarea class="form-control" name="text" id="text" value="{{old('text', $comment->text ?? '')}}"></textarea>
    </div>
    <div class="mb-3">
        <input type="file" class="form-control" id="file">
    </div>
    <div class="row">
        <button type="submit" class="btn btn-primary">Küldés</button>
    </div>
</form>
@endsection
