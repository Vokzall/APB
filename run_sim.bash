#!/bin/bash
xrun \
 -access +rwc \
 -turbo \
 -sv \
 *.svh *.sv \
 -top tb_apb \
 -gui \
 -define +XCEL