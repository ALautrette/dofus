@extends('layouts.app')

@section('content')
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card">

                    <div class="card-body">
                        @if (session('status'))
                            <div class="alert alert-success" role="alert">
                                {{ session('status') }}
                            </div>
                        @endif

                            <form action="{{ url('users') }}" method="POST">
                                @csrf
                                <label for="nom">Entrez votre nom : </label>
                                <input type="text" name="nom" id="nom">
                                <input type="submit" value="Envoyer !">
                            </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
@endsection
