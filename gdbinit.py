#!/usr/bin/env python

from __future__ import print_function

PSR_N = 1 << 31
PSR_Z = 1 << 30
PSR_C = 1 << 29
PSR_V = 1 << 28
PSR_Q = 1 << 27
PSR_IT10 = lambda psr: (psr >> 25) & 0b11
PSR_J = 1 << 24
PSR_GE = lambda psr: (psr >> 16) & 0b1111
PSR_IT72 = lambda psr: (psr >> 10) & 0b111111
PSR_E = 1 << 9
PSR_A = 1 << 8
PSR_I = 1 << 7
PSR_F = 1 << 6
PSR_T = 1 << 5
PSR_M = lambda psr: psr & 0b11111

ANSI_RESET = "\033[0m"
ANSI_BOLD = "\033[1m"
ANSI_TBL0 = ANSI_RESET
ANSI_TBL1 = "\033[38;5;247m"
ANSI_RED = "\033[31m"
ANSI_GREEN = "\033[32m"
ANSI_YELLOW = "\033[33m"
ANSI_BLUE = "\033[34m"
ANSI_CYAN = "\033[36m"

class ARMRegs(gdb.Command):
    """Print out ARM registers"""

    def __init__(self):
        super(ARMRegs, self).__init__("arm-regs", gdb.COMMAND_USER)

    def invoke(self, arg, from_tty):
        regs = gdb.execute("info reg", to_string=True).strip().split("\n")
        regs = map(lambda r: r.split(), regs)
        regs = dict(map(lambda r: [r[0], int(r[1], 16)], regs))
        print("{}----+----HEX---+--UNSIGNED--+---SIGNED---".format(ANSI_BOLD))
        for i, reg in enumerate(["r0", "r1", "r2", "r3", "r4", "r5", "r6",
                                 "r7", "r8", "r9", "r10", "r11", "r12", "sp",
                                 "lr", "pc"]):
            if i % 2 == 0:
                print(ANSI_TBL0, end='')
            else:
                print(ANSI_TBL1, end='')
            self.print_reg(reg, regs[reg])
        print(ANSI_RESET, end='')

        print("{}----+----------+------------+------------{}".format(
            ANSI_BOLD, ANSI_RESET))
        print("")
        cpsr = self.parse_psr(regs["cpsr"])
        self.print_psr("cpsr", cpsr)
        spsr = gdb.execute("info reg spsr_{}".format(cpsr["mode"]),
                           to_string=True).strip().split()[1]
        spsr = self.parse_psr(int(spsr, 16))
        self.print_psr("spsr", spsr)

    def print_reg(self, name, val):
        print("{:<3} | {:0>8X} | {:>10d} | {:>11d}".format(
            name.upper(), val, val, -((~val) + 1)
        ))

    def parse_psr(self, val):
        psr = {}
        psr["n"] = bool(val & PSR_N)
        psr["z"] = bool(val & PSR_Z)
        psr["c"] = bool(val & PSR_C)
        psr["v"] = bool(val & PSR_V)
        psr["q"] = bool(val & PSR_Q)
        psr["j"] = bool(val & PSR_J)
        psr["e"] = bool(val & PSR_E)
        psr["a"] = bool(val & PSR_A)
        psr["i"] = bool(val & PSR_I)
        psr["f"] = bool(val & PSR_F)
        psr["t"] = bool(val & PSR_T)
        psr["m"] = PSR_M(val)
        psr["ge"] = PSR_GE(val)
        psr["it"] = (PSR_IT72(val) << 2) | PSR_IT10(val)

        if psr["m"] == 0b10000:
            psr["mode"] = "usr"
        elif psr["m"] == 0b10001:
            psr["mode"] = "fiq"
        elif psr["m"] == 0b10010:
            psr["mode"] = "irq"
        elif psr["m"] == 0b10011:
            psr["mode"] = "svc"
        elif psr["m"] == 0b10110:
            psr["mode"] = "mon"
        elif psr["m"] == 0b11010:
            psr["mode"] = "hyp"
        elif psr["m"] == 0b11011:
            psr["mode"] = "und"
        elif psr["m"] == 0b11111:
            psr["mode"] = "sys"
        else:
            psr["mode"] = "???"

        return psr

    def print_psr(self, name, psr):
        mode_col = ANSI_YELLOW
        if psr["mode"] in ("mon", "hyp"):
            mode_col = ANSI_RED
        elif psr["mode"] == "usr":
            mode_col = ANSI_GREEN
        name_col = ANSI_CYAN if name == "cpsr" else ANSI_BLUE

        print(
            "{}{}{}: {}{}{} | ".format(
                ANSI_BOLD, name_col, name.upper(), mode_col,
                psr["mode"].upper(), ANSI_RESET),
            end='')
        for flag in "nzcvq":
            if psr[flag]:
                print(flag.upper(), end='')
            else:
                print(' ', end='')
        print(" | {}".format(ANSI_RED), end='')

        for bit in "jeaift":
            if psr[bit]:
                print(bit.upper(), end='')
            else:
                print(' ', end='')

        print(ANSI_RESET)


ARMRegs()
