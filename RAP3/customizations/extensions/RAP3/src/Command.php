<?php

namespace Ampersand\Extension\RAP3;

use Psr\Log\LoggerInterface;

class Command
{
    /**
     * Command to execute
     *
     * @var string
     */
    protected $cmd;

    /**
     * List of arguments for the command
     *
     * @var string[]
     */
    protected $args;

    /**
     * Exit code returned after execution of command
     *
     * @var int
     */
    protected $exitcode = null;

    /**
     * Standard out after execution of command
     *
     * @var array
     */
    protected $stdout = null;

    /**
     * Logger
     */
    protected $logger = null;

    public function __construct(string $cmd, array $args = null, LoggerInterface $logger = null)
    {
        $this->cmd = $cmd;
        $this->args = $args;
        $this->setLogger($logger);
    }

    public function setLogger(LoggerInterface $logger)
    {
        $this->logger = $logger;
    }

    public function execute(string $workdir = null)
    {
        $cmd = $this->cmd . ' ' . implode(' ', $this->args);

        $cmd .= ' 2>&1'; // appends STDERR to STDOUT, which is then available in $output below

        // Change working dir
        if (isset($workdir)) {
            chdir($workdir);
        }
        $cwd = getcwd();

        $this->log('info', "Executing cmd: '{$cmd}' (cwd: '{$cwd}')");

        exec($cmd, $output, $exitcode);

        $this->stdout = $output;
        $this->exitcode = $exitcode;

        $this->log('debug', "Exitcode: '{$this->exitcode}' with response: '{$this->getResponse()}'");
    }

    public function getExitcode(): int
    {
        return (int) $this->exitcode;
    }

    public function getResponse(): string
    {
        return implode("\n", $this->stdout);
    }

    protected function log(string $level, string $message)
    {
        if (isset($this->logger)) {
            $this->logger->log($level, $message);
        }
    }
}
