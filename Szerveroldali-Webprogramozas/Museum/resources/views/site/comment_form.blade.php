@extends('layouts.layout')

@section('title','Edit Comment')

@section('content')
<h2>Edit your comment</h2>
<form action="{{ isset($comment) ? route('items.updateComment', ['comment' => $comment->id]) : ''}}" method="post">
    @csrf
    <div class="mb-3">
        <textarea class="form-control" name="text" id="text">{{old('text', $comment->text ?? '')}}</textarea>
    </div>
    <div class="row">
        <button type="submit" class="btn btn-primary">Comment</button>
    </div>
</form>
@endsectionz
