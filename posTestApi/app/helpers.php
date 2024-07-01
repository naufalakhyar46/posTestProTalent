<?php

function success($data=[],$msg=null)
{
    $resp = array(
        'status' => 'success',
        'message' => !empty($msg) ? $msg : 'Data Found',
        'code' => 200,
        'data' => $data
    );

    return response()->json($resp, 200);
}

function successMessage($message)
{
    $resp = array(
        'status' => 'success',
        'message' => !empty($message) ? $message : 'Data Found',
        'code' => 200
    );

    return response()->json($resp, 200);
}

function successAdd($msgMod='')
{
    $resp = array(
        'status' => 'success',
        'message' => 'Data '.$msgMod.' added successfully',
        'code' => 200,
    );

    return response()->json($resp, 200);
}

function successUpdate($msgMod='')
{
    $resp = array(
        'status' => 'success',
        'message' => 'Data '.$msgMod.' updated successfully',
        'code' => 200,
    );

    return response()->json($resp, 200);
}

function successDelete($msgMod='')
{
    $resp = array(
        'status' => 'success',
        'message' => 'Data '.$msgMod.' deleted successfully',
        'code' => 200,
    );

    return response()->json($resp, 200);
}

function errorForm($msg, $code = 400, $data = null)
{
    $resp = array(
        'status' => 'error',
        'code' => $code,
        'message' => $msg
    );

    if($data != null){
        $resp['data'] = $data;
    }

    return response()->json($resp, 400);
}

function errorRespApi($message)
{
    $resp = array(
        'status' => 'error',
        'code' => 400,
        'message' => $message ? $message : "Data not Found"
    );

    return response()->json($resp, 400);
}
