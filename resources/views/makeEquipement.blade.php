@extends('layouts.app')

@section('content')
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card">
                    <div class="card-header">{{ __('Dashboard') }}</div>

                    <div class="card-body">
                        @if (session('status'))
                            <div class="alert alert-success" role="alert">
                                {{ session('status') }}
                            </div>
                        @endif

                        {{ __('You are logged in!') }}

                        <li class="nav-item dropdown">
                            <a id="navbarDropdown" class="nav-link dropdown-toggle" href="{{ route('home') }}" role="button" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false" v-pre>
                                {{ __('Retour a l\'acceuille') }}
                            </a>
                        </li>
                        <li class="nav-item dropdown">
                            <a id="navbarDropdown" class="nav-link dropdown-toggle" href="{{ route('equipement_enregistrer') }}" role="button" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false" v-pre>
                                {{ __('voir les équipement enregistrer') }}
                            </a>
                        </li>
                        <form method="post" action="{{route("saveequipement")}}" id="FormulaireClasse">
                            @csrf
                            <label for="nomEquipement">Nom de l'equipement</label>
                            <input type="text" name="nomEquipement" placeholder="Nom">

                            <label for="classe">Classe</label>
                            <select name="classe" id="classe">
                                @foreach($classes as $classe)
                                    <option value="{{$classe->id}}">{{$classe->nom}}</option>
                                @endforeach
                            </select>
                        </form>
                        <button form="FormulaireClasse"> Créer </button>

                    </div>
                </div>
            </div>
        </div>
    </div>

@endsection
