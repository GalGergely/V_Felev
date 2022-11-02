@extends('layouts.layout')

@section('title', @isset($item) ? 'Edit Item' : 'New Item')

@php
    use App\Models\Label;
    $labels=Label::all();
@endphp

@section('content')
        <div class="container-fluid px-5 my-3">
            <h1 class="ps-3">{{isset($item) ? 'Edit item' : 'New Item'}}</h1>
            <hr />
            <form method="post" enctype="multipart/form-data" action="{{ isset($item) ? route('items.update', ['item' => $item->id]) : route('items.store')}}">
                @csrf
                @isset($item)
                    @method('put')
                @endisset
                <div class="row mb-3">
                    <div class="col">
                        <input
                            type="text"
                            class="form-control @error('name') is-invalid @enderror"
                            placeholder="Item"
                            name="name"
                            id="name"
                            value="{{old('name',$item->name ?? '')}}"
                        />
                        @error('name')
                            <div class="invalid-feedback">
                                {{ $message }}
                            </div>
                        @enderror
                    </div>
                    <div class="col">
                        <input type="date"class="form-control @error('obtained') is-invalid @enderror" id="obtained" name="obtained" value="{{old('obtained', $item->obtained ?? '')}}">
                        @error('obtained')
                        <div class="invalid-feedback">
                            {{ $message }}
                        </div>
                        @enderror
                    </div>
                </div>
                <div class="mb-3">
                    <textarea class="form-control @error('description') is-invalid @enderror" id="description" name="description" placeholder="Item description">{{old('description',$item->description ?? '')}}</textarea>
                @error('description')
                    <div class="invalid-feedback">
                        {{ $message }}
                    </div>
                @enderror
                </div>
                <div class="col">
                    <!--HELP: a lenyilotol hasonlo-->
                        @foreach ($labels as $label)
                        @if (isset($item))
                        <input type="checkbox" id="{{$label->id}}" name="labels[]" value="{{$label->id}}" {{ old('labels[]', $item->labels()->find($label->id)->id ?? '') == $label->id ? 'checked' : '' }}>{{$label->name}}<br>
                        @else
                        <input type="checkbox" id="{{$label->id}}" name="labels[]" value="{{$label->id}}">{{$label->name}}<br>
                        @endif
                        @endforeach
                </div>
                <div class="mb-3">
                    <input type="file" class="form-control @error('image') is-invalid @enderror" id="cover_image" name="image">
                    @error('image')
                    <div class="invalid-feedback">
                        {{ $message }}
                    </div>
                    @enderror
                    <div id="cover_preview" class="col-12 d-none">
                        <p>Cover preview:</p>
                        <img width=500 id="cover_preview_image" src="#" alt="Cover preview">
                    </div>
                </div>
                <div class="row">
                    <button type="submit" class="btn btn-primary">Save Item</button>
                </div>
            </form>
        </div>
        <script
            src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"
            integrity="sha384-ka7Sk0Gln4gmtz2MlQnikT1wXgYsOg+OMhuP+IlRH9sENBO0LRn5q+8nbTov4+1p"
            crossorigin="anonymous"
        ></script>


@endsection

@section('scripts')
    <script>
        const coverImageInput = document.querySelector('input#cover_image');
        const coverPreviewContainer = document.querySelector('#cover_preview');
        const coverPreviewImage = document.querySelector('img#cover_preview_image');

        coverImageInput.onchange = event => {
            const [file] = coverImageInput.files;
            if (file) {
                coverPreviewContainer.classList.remove('d-none');
                coverPreviewImage.src = URL.createObjectURL(file);
            } else {
                coverPreviewContainer.classList.add('d-none');
            }
        }
    </script>
@endsection

