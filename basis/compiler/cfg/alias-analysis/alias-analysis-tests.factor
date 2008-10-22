USING: compiler.cfg.instructions compiler.cfg.registers
compiler.cfg.alias-analysis cpu.architecture tools.test
kernel ;
IN: compiler.cfg.alias-analysis.tests

[ ] [
    {
        T{ ##load-indirect f V int-regs 1 "hello" }
        T{ ##slot-imm f V int-regs 0 V int-regs 1 0 3 }
    } alias-analysis drop
] unit-test

[
    {
        T{ ##peek f V int-regs 1 D 1 }
        T{ ##replace f V int-regs 1 D 0 }
    }
] [
    {
        T{ ##peek f V int-regs 1 D 1 }
        T{ ##replace f V int-regs 1 D 0 }
        T{ ##replace f V int-regs 1 D 1 }
    } alias-analysis
] unit-test

[
    {
        T{ ##peek f V int-regs 1 D 1 }
        T{ ##copy f V int-regs 2 V int-regs 1 }
        T{ ##replace f V int-regs 2 D 0 }
    }
] [
    {
        T{ ##peek f V int-regs 1 D 1 }
        T{ ##copy f V int-regs 2 V int-regs 1 }
        T{ ##replace f V int-regs 2 D 0 }
        T{ ##replace f V int-regs 2 D 1 }
    } alias-analysis
] unit-test

[
    {
        T{ ##peek f V int-regs 1 D 1 }
        T{ ##peek f V int-regs 2 D 0 }
        T{ ##copy f V int-regs 3 V int-regs 2 }
        T{ ##copy f V int-regs 4 V int-regs 1 }
    }
] [
    {
        T{ ##peek f V int-regs 1 D 1 }
        T{ ##peek f V int-regs 2 D 0 }
        T{ ##copy f V int-regs 3 V int-regs 2 }
        T{ ##copy f V int-regs 4 V int-regs 1 }
        T{ ##replace f V int-regs 3 D 0 }
        T{ ##replace f V int-regs 4 D 1 }
    } alias-analysis
] unit-test

[
    {
        T{ ##peek f V int-regs 1 D 1 f }
        T{ ##peek f V int-regs 2 D 2 f }
        T{ ##replace f V int-regs 1 D 0 f }
    }
] [
    {
        T{ ##peek f V int-regs 1 D 1 f }
        T{ ##peek f V int-regs 2 D 2 f }
        T{ ##replace f V int-regs 2 D 0 f }
        T{ ##replace f V int-regs 1 D 0 f }
    } alias-analysis
] unit-test

[
    {
        T{ ##peek f V int-regs 1 D 1 f }
        T{ ##copy f V int-regs 3 V int-regs 1 f }
    }
] [
    {
        T{ ##peek f V int-regs 1 D 1 f }
        T{ ##replace f V int-regs 1 D 1 f }
        T{ ##peek f V int-regs 3 D 1 f }
        T{ ##replace f V int-regs 4 D 1 f }
    } alias-analysis
] unit-test

[
    {
        T{ ##peek f V int-regs 1 D 1 f }
        T{ ##peek f V int-regs 2 D 0 f }
    }
] [
    {
        T{ ##peek f V int-regs 1 D 1 f }
        T{ ##peek f V int-regs 2 D 0 f }
        T{ ##replace f V int-regs 1 D 0 f }
        T{ ##replace f V int-regs 2 D 1 f }
        T{ ##replace f V int-regs 2 D 0 f }
        T{ ##replace f V int-regs 1 D 1 f }
    } alias-analysis
] unit-test

[
    {
        T{ ##peek f V int-regs 1 D 1 f }
        T{ ##peek f V int-regs 2 D 0 f }
        T{ ##copy f V int-regs 3 V int-regs 2 f }
        T{ ##copy f V int-regs 4 V int-regs 1 f }
    }
] [
    {
        T{ ##peek f V int-regs 1 D 1 f }
        T{ ##peek f V int-regs 2 D 0 f }
        T{ ##replace f V int-regs 1 D 0 f }
        T{ ##replace f V int-regs 2 D 1 f }
        T{ ##peek f V int-regs 3 D 1 f }
        T{ ##peek f V int-regs 4 D 0 f }
        T{ ##replace f V int-regs 3 D 0 f }
        T{ ##replace f V int-regs 4 D 1 f }
    } alias-analysis
] unit-test
