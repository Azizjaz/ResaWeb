<?php

namespace App\Controllers;

class Test extends BaseController
{
    public function index()
    {
        return view('templates/haut_admin')
             . view('testview')
             . view('templates/bas_admin');
    }
}
