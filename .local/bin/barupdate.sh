#!/bin/sh

ps -C "bar" -o pid= | xargs kill -ALRM
