<?php

namespace RAP4;

interface DeploymentInterface {
    public function __construct($userName, $ee);
    public function deploy();
}
