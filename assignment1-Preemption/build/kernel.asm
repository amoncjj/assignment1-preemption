
build/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080200000 <_entry>:
    .section .text.entry
    .globl _entry
_entry:
    lla sp, boot_stack_top
    80200000:	00009117          	auipc	sp,0x9
    80200004:	00010113          	mv	sp,sp
    call bootcpu_entry
    80200008:	00002097          	auipc	ra,0x2
    8020000c:	028080e7          	jalr	40(ra) # 80202030 <bootcpu_entry>

0000000080200010 <_entry_secondary_cpu>:

.globl _entry_secondary_cpu
_entry_secondary_cpu:
    # RISC-V SBI Spec: Ch.9 Hart State Management Extension
    #    sbi_hart_start: a0: hartid, a1: opaque
    fence.i
    80200010:	0000100f          	fence.i
    lla sp, boot_stack_top
    80200014:	00009117          	auipc	sp,0x9
    80200018:	fec10113          	addi	sp,sp,-20 # 80209000 <uart_tx_lock>
    call secondarycpu_entry
    8020001c:	00002097          	auipc	ra,0x2
    80200020:	158080e7          	jalr	344(ra) # 80202174 <secondarycpu_entry>

0000000080200024 <kernel_trap_entry>:

    .globl kernel_trap_entry
    .align 2
kernel_trap_entry:
    // we store all registers in the stack
    add sp, sp, -0x100
    80200024:	f0010113          	addi	sp,sp,-256
    sd x0, 0x00(sp)
    80200028:	00013023          	sd	zero,0(sp)
    sd x1, 0x08(sp)
    8020002c:	00113423          	sd	ra,8(sp)
    sd x2, 0x10(sp)
    80200030:	00213823          	sd	sp,16(sp)
    sd x3, 0x18(sp)
    80200034:	00313c23          	sd	gp,24(sp)
    sd x4, 0x20(sp)
    80200038:	02413023          	sd	tp,32(sp)
    sd x5, 0x28(sp)
    8020003c:	02513423          	sd	t0,40(sp)
    sd x6, 0x30(sp)
    80200040:	02613823          	sd	t1,48(sp)
    sd x7, 0x38(sp)
    80200044:	02713c23          	sd	t2,56(sp)
    sd x8, 0x40(sp)
    80200048:	04813023          	sd	s0,64(sp)
    sd x9, 0x48(sp)
    8020004c:	04913423          	sd	s1,72(sp)
    sd x10, 0x50(sp)
    80200050:	04a13823          	sd	a0,80(sp)
    sd x11, 0x58(sp)
    80200054:	04b13c23          	sd	a1,88(sp)
    sd x12, 0x60(sp)
    80200058:	06c13023          	sd	a2,96(sp)
    sd x13, 0x68(sp)
    8020005c:	06d13423          	sd	a3,104(sp)
    sd x14, 0x70(sp)
    80200060:	06e13823          	sd	a4,112(sp)
    sd x15, 0x78(sp)
    80200064:	06f13c23          	sd	a5,120(sp)
    sd x16, 0x80(sp)
    80200068:	09013023          	sd	a6,128(sp)
    sd x17, 0x88(sp)
    8020006c:	09113423          	sd	a7,136(sp)
    sd x18, 0x90(sp)
    80200070:	09213823          	sd	s2,144(sp)
    sd x19, 0x98(sp)
    80200074:	09313c23          	sd	s3,152(sp)
    sd x20, 0xa0(sp)
    80200078:	0b413023          	sd	s4,160(sp)
    sd x21, 0xa8(sp)
    8020007c:	0b513423          	sd	s5,168(sp)
    sd x22, 0xb0(sp)
    80200080:	0b613823          	sd	s6,176(sp)
    sd x23, 0xb8(sp)
    80200084:	0b713c23          	sd	s7,184(sp)
    sd x24, 0xc0(sp)
    80200088:	0d813023          	sd	s8,192(sp)
    sd x25, 0xc8(sp)
    8020008c:	0d913423          	sd	s9,200(sp)
    sd x26, 0xd0(sp)
    80200090:	0da13823          	sd	s10,208(sp)
    sd x27, 0xd8(sp)
    80200094:	0db13c23          	sd	s11,216(sp)
    sd x28, 0xe0(sp)
    80200098:	0fc13023          	sd	t3,224(sp)
    sd x29, 0xe8(sp)
    8020009c:	0fd13423          	sd	t4,232(sp)
    sd x30, 0xf0(sp)
    802000a0:	0fe13823          	sd	t5,240(sp)
    sd x31, 0xf8(sp)
    802000a4:	0ff13c23          	sd	t6,248(sp)

    mv a0, sp   // make a0 point to the ktrapframe structure
    802000a8:	00010513          	mv	a0,sp
    call kernel_trap
    802000ac:	00004097          	auipc	ra,0x4
    802000b0:	6d0080e7          	jalr	1744(ra) # 8020477c <kernel_trap>

    // restore all registers
    ld x0, 0x00(sp)
    802000b4:	00013003          	ld	zero,0(sp)
    ld x1, 0x08(sp)
    802000b8:	00813083          	ld	ra,8(sp)
    ld x2, 0x10(sp)
    802000bc:	01013103          	ld	sp,16(sp)
    ld x3, 0x18(sp)
    802000c0:	01813183          	ld	gp,24(sp)
    // do not recover tp(x4), in case we have moved CPUs: ld x4, 0x20(sp)
    ld x5, 0x28(sp)
    802000c4:	02813283          	ld	t0,40(sp)
    ld x6, 0x30(sp)
    802000c8:	03013303          	ld	t1,48(sp)
    ld x7, 0x38(sp)
    802000cc:	03813383          	ld	t2,56(sp)
    ld x8, 0x40(sp)
    802000d0:	04013403          	ld	s0,64(sp)
    ld x9, 0x48(sp)
    802000d4:	04813483          	ld	s1,72(sp)
    ld x10, 0x50(sp)
    802000d8:	05013503          	ld	a0,80(sp)
    ld x11, 0x58(sp)
    802000dc:	05813583          	ld	a1,88(sp)
    ld x12, 0x60(sp)
    802000e0:	06013603          	ld	a2,96(sp)
    ld x13, 0x68(sp)
    802000e4:	06813683          	ld	a3,104(sp)
    ld x14, 0x70(sp)
    802000e8:	07013703          	ld	a4,112(sp)
    ld x15, 0x78(sp)
    802000ec:	07813783          	ld	a5,120(sp)
    ld x16, 0x80(sp)
    802000f0:	08013803          	ld	a6,128(sp)
    ld x17, 0x88(sp)
    802000f4:	08813883          	ld	a7,136(sp)
    ld x18, 0x90(sp)
    802000f8:	09013903          	ld	s2,144(sp)
    ld x19, 0x98(sp)
    802000fc:	09813983          	ld	s3,152(sp)
    ld x20, 0xa0(sp)
    80200100:	0a013a03          	ld	s4,160(sp)
    ld x21, 0xa8(sp)
    80200104:	0a813a83          	ld	s5,168(sp)
    ld x22, 0xb0(sp)
    80200108:	0b013b03          	ld	s6,176(sp)
    ld x23, 0xb8(sp)
    8020010c:	0b813b83          	ld	s7,184(sp)
    ld x24, 0xc0(sp)
    80200110:	0c013c03          	ld	s8,192(sp)
    ld x25, 0xc8(sp)
    80200114:	0c813c83          	ld	s9,200(sp)
    ld x26, 0xd0(sp)
    80200118:	0d013d03          	ld	s10,208(sp)
    ld x27, 0xd8(sp)
    8020011c:	0d813d83          	ld	s11,216(sp)
    ld x28, 0xe0(sp)
    80200120:	0e013e03          	ld	t3,224(sp)
    ld x29, 0xe8(sp)
    80200124:	0e813e83          	ld	t4,232(sp)
    ld x30, 0xf0(sp)
    80200128:	0f013f03          	ld	t5,240(sp)
    ld x31, 0xf8(sp)
    8020012c:	0f813f83          	ld	t6,248(sp)

    // restore stack
    add sp, sp, 0x100
    80200130:	10010113          	addi	sp,sp,256

    // return from trap
    sret
    80200134:	10200073          	sret

0000000080200138 <consputc>:
    uint r;  // Read index
    uint w;  // Write index
    uint e;  // Edit index
} cons;

void consputc(int c) {
    80200138:	ff010113          	addi	sp,sp,-16
    8020013c:	00813423          	sd	s0,8(sp)
    80200140:	01010413          	addi	s0,sp,16
    if (!uart_inited || panicked)  // when panicked, use SBI output
    80200144:	0001e797          	auipc	a5,0x1e
    80200148:	2087a783          	lw	a5,520(a5) # 8021e34c <uart_inited>
    8020014c:	06078a63          	beqz	a5,802001c0 <consputc+0x88>
    80200150:	0001e797          	auipc	a5,0x1e
    80200154:	1f87a783          	lw	a5,504(a5) # 8021e348 <panicked>
    80200158:	06079463          	bnez	a5,802001c0 <consputc+0x88>
        sbi_putchar(c);
    else {
        if (c == BACKSPACE) {
    8020015c:	10000793          	li	a5,256
}

// disable device interrupts, return whether it opens before off.
static inline int64 intr_off() {
    uint64 prev;
    asm volatile("csrrc %0, sstatus, %1" : "=r"(prev) : "r"(SSTATUS_SIE));
    80200160:	00200693          	li	a3,2
    80200164:	06f50663          	beq	a0,a5,802001d0 <consputc+0x98>
    80200168:	1006b6f3          	csrrc	a3,sstatus,a3
    }
}

static void uart_putchar(int ch) {
    int intr = intr_off();
    while ((ReadReg(LSR) & LSR_TX_IDLE) == 0) MEMORY_FENCE();
    8020016c:	10000737          	lui	a4,0x10000
    80200170:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x701ffffb>
    return (prev & SSTATUS_SIE) != 0;
    80200174:	0026f693          	andi	a3,a3,2
    80200178:	00570713          	addi	a4,a4,5
    8020017c:	0207f793          	andi	a5,a5,32
    80200180:	00079a63          	bnez	a5,80200194 <consputc+0x5c>
    80200184:	0ff0000f          	fence
    80200188:	00074783          	lbu	a5,0(a4)
    8020018c:	0207f793          	andi	a5,a5,32
    80200190:	fe078ae3          	beqz	a5,80200184 <consputc+0x4c>
    MEMORY_FENCE();
    80200194:	0ff0000f          	fence

    WriteReg(THR, ch);
    80200198:	100007b7          	lui	a5,0x10000
    8020019c:	0ff57513          	zext.b	a0,a0
    802001a0:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70200000>
    MEMORY_FENCE();
    802001a4:	0ff0000f          	fence
    if (intr)
    802001a8:	00068663          	beqz	a3,802001b4 <consputc+0x7c>
    asm volatile("csrrs x0, sstatus, %0" ::"r"(SSTATUS_SIE));
    802001ac:	00200793          	li	a5,2
    802001b0:	1007a073          	csrs	sstatus,a5
}
    802001b4:	00813403          	ld	s0,8(sp)
    802001b8:	01010113          	addi	sp,sp,16
    802001bc:	00008067          	ret
    802001c0:	00813403          	ld	s0,8(sp)
    802001c4:	01010113          	addi	sp,sp,16
        sbi_putchar(c);
    802001c8:	00003317          	auipc	t1,0x3
    802001cc:	67c30067          	jr	1660(t1) # 80203844 <sbi_putchar>
    asm volatile("csrrc %0, sstatus, %1" : "=r"(prev) : "r"(SSTATUS_SIE));
    802001d0:	1006b6f3          	csrrc	a3,sstatus,a3
    while ((ReadReg(LSR) & LSR_TX_IDLE) == 0) MEMORY_FENCE();
    802001d4:	10000737          	lui	a4,0x10000
    802001d8:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x701ffffb>
    return (prev & SSTATUS_SIE) != 0;
    802001dc:	0026f693          	andi	a3,a3,2
    802001e0:	00570713          	addi	a4,a4,5
    802001e4:	0207f793          	andi	a5,a5,32
    802001e8:	00079a63          	bnez	a5,802001fc <consputc+0xc4>
    802001ec:	0ff0000f          	fence
    802001f0:	00074783          	lbu	a5,0(a4)
    802001f4:	0207f793          	andi	a5,a5,32
    802001f8:	fe078ae3          	beqz	a5,802001ec <consputc+0xb4>
    MEMORY_FENCE();
    802001fc:	0ff0000f          	fence
    WriteReg(THR, ch);
    80200200:	100007b7          	lui	a5,0x10000
    80200204:	00800713          	li	a4,8
    80200208:	00e78023          	sb	a4,0(a5) # 10000000 <_entry-0x70200000>
    MEMORY_FENCE();
    8020020c:	0ff0000f          	fence
    if (intr)
    80200210:	00068663          	beqz	a3,8020021c <consputc+0xe4>
    asm volatile("csrrs x0, sstatus, %0" ::"r"(SSTATUS_SIE));
    80200214:	00200793          	li	a5,2
    80200218:	1007a073          	csrs	sstatus,a5
    asm volatile("csrrc %0, sstatus, %1" : "=r"(prev) : "r"(SSTATUS_SIE));
    8020021c:	00200693          	li	a3,2
    80200220:	1006b6f3          	csrrc	a3,sstatus,a3
    while ((ReadReg(LSR) & LSR_TX_IDLE) == 0) MEMORY_FENCE();
    80200224:	10000737          	lui	a4,0x10000
    80200228:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x701ffffb>
    return (prev & SSTATUS_SIE) != 0;
    8020022c:	0026f693          	andi	a3,a3,2
    80200230:	00570713          	addi	a4,a4,5
    80200234:	0207f793          	andi	a5,a5,32
    80200238:	00079a63          	bnez	a5,8020024c <consputc+0x114>
    8020023c:	0ff0000f          	fence
    80200240:	00074783          	lbu	a5,0(a4)
    80200244:	0207f793          	andi	a5,a5,32
    80200248:	fe078ae3          	beqz	a5,8020023c <consputc+0x104>
    MEMORY_FENCE();
    8020024c:	0ff0000f          	fence
    WriteReg(THR, ch);
    80200250:	100007b7          	lui	a5,0x10000
    80200254:	02000713          	li	a4,32
    80200258:	00e78023          	sb	a4,0(a5) # 10000000 <_entry-0x70200000>
    MEMORY_FENCE();
    8020025c:	0ff0000f          	fence
    if (intr)
    80200260:	00068663          	beqz	a3,8020026c <consputc+0x134>
    asm volatile("csrrs x0, sstatus, %0" ::"r"(SSTATUS_SIE));
    80200264:	00200793          	li	a5,2
    80200268:	1007a073          	csrs	sstatus,a5
    asm volatile("csrrc %0, sstatus, %1" : "=r"(prev) : "r"(SSTATUS_SIE));
    8020026c:	00200693          	li	a3,2
    80200270:	1006b6f3          	csrrc	a3,sstatus,a3
    while ((ReadReg(LSR) & LSR_TX_IDLE) == 0) MEMORY_FENCE();
    80200274:	10000737          	lui	a4,0x10000
    80200278:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x701ffffb>
    return (prev & SSTATUS_SIE) != 0;
    8020027c:	0026f693          	andi	a3,a3,2
    80200280:	00570713          	addi	a4,a4,5
    80200284:	0207f793          	andi	a5,a5,32
    80200288:	00079a63          	bnez	a5,8020029c <consputc+0x164>
    8020028c:	0ff0000f          	fence
    80200290:	00074783          	lbu	a5,0(a4)
    80200294:	0207f793          	andi	a5,a5,32
    80200298:	fe078ae3          	beqz	a5,8020028c <consputc+0x154>
    MEMORY_FENCE();
    8020029c:	0ff0000f          	fence
    WriteReg(THR, ch);
    802002a0:	100007b7          	lui	a5,0x10000
    802002a4:	00800713          	li	a4,8
    802002a8:	00e78023          	sb	a4,0(a5) # 10000000 <_entry-0x70200000>
    MEMORY_FENCE();
    802002ac:	0ff0000f          	fence
    if (intr)
    802002b0:	f00682e3          	beqz	a3,802001b4 <consputc+0x7c>
    802002b4:	ef9ff06f          	j	802001ac <consputc+0x74>

00000000802002b8 <console_init>:
        intr_on();
}

void console_init() {
    802002b8:	fe010113          	addi	sp,sp,-32
    802002bc:	00813823          	sd	s0,16(sp)
    802002c0:	00913423          	sd	s1,8(sp)
    802002c4:	00113c23          	sd	ra,24(sp)
    802002c8:	02010413          	addi	s0,sp,32
    assert(!uart_inited);
    802002cc:	0001e497          	auipc	s1,0x1e
    802002d0:	08048493          	addi	s1,s1,128 # 8021e34c <uart_inited>
    802002d4:	0004a783          	lw	a5,0(s1)
    802002d8:	0a079663          	bnez	a5,80200384 <console_init+0xcc>
    spinlock_init(&uart_tx_lock, "uart_tx");
    802002dc:	00005597          	auipc	a1,0x5
    802002e0:	d8c58593          	addi	a1,a1,-628 # 80205068 <e_text+0x68>
    802002e4:	00009517          	auipc	a0,0x9
    802002e8:	d1c50513          	addi	a0,a0,-740 # 80209000 <uart_tx_lock>
    802002ec:	00001097          	auipc	ra,0x1
    802002f0:	5d8080e7          	jalr	1496(ra) # 802018c4 <spinlock_init>
    spinlock_init(&cons.lock, "cons");
    802002f4:	00005597          	auipc	a1,0x5
    802002f8:	d7c58593          	addi	a1,a1,-644 # 80205070 <e_text+0x70>
    802002fc:	00009517          	auipc	a0,0x9
    80200300:	d2450513          	addi	a0,a0,-732 # 80209020 <cons>
    80200304:	00001097          	auipc	ra,0x1
    80200308:	5c0080e7          	jalr	1472(ra) # 802018c4 <spinlock_init>

    // disable interrupts.
    WriteReg(IER, 0x00);
    8020030c:	100007b7          	lui	a5,0x10000
    80200310:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x701fffff>
    MEMORY_FENCE();
    80200314:	0ff0000f          	fence
    WriteReg(IER, 0x00);
    80200318:	00178793          	addi	a5,a5,1

    // special mode to set baud rate.
    WriteReg(LCR, LCR_BAUD_LATCH);
    8020031c:	10000737          	lui	a4,0x10000
    80200320:	00370713          	addi	a4,a4,3 # 10000003 <_entry-0x701ffffd>
    80200324:	f8000693          	li	a3,-128
    80200328:	00d70023          	sb	a3,0(a4)
    MEMORY_FENCE();
    8020032c:	0ff0000f          	fence

    // LSB for baud rate of 38.4K.
    WriteReg(0, 0x03);
    80200330:	00300693          	li	a3,3
    80200334:	10000637          	lui	a2,0x10000
    80200338:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70200000>
    MEMORY_FENCE();
    8020033c:	0ff0000f          	fence

    // MSB for baud rate of 38.4K.
    WriteReg(1, 0x00);
    80200340:	00078023          	sb	zero,0(a5)
    MEMORY_FENCE();
    80200344:	0ff0000f          	fence
    // leave set-baud mode,

    // and set word length to 8 bits, no parity.
    WriteReg(LCR, LCR_EIGHT_BITS);
    80200348:	00d70023          	sb	a3,0(a4)
    MEMORY_FENCE();
    8020034c:	0ff0000f          	fence

    // reset and enable FIFOs.
    WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80200350:	10000737          	lui	a4,0x10000
    80200354:	00700693          	li	a3,7
    80200358:	00d70123          	sb	a3,2(a4) # 10000002 <_entry-0x701ffffe>
    MEMORY_FENCE();
    8020035c:	0ff0000f          	fence

    // enable receive interrupts.
    WriteReg(IER, IER_RX_ENABLE);
    80200360:	00100713          	li	a4,1
    80200364:	00e78023          	sb	a4,0(a5)
    MEMORY_FENCE();
    80200368:	0ff0000f          	fence
    uart_inited = true;
}
    8020036c:	01813083          	ld	ra,24(sp)
    80200370:	01013403          	ld	s0,16(sp)
    uart_inited = true;
    80200374:	00e4a023          	sw	a4,0(s1)
}
    80200378:	00813483          	ld	s1,8(sp)
    8020037c:	02010113          	addi	sp,sp,32
    80200380:	00008067          	ret

// read and write tp, the thread pointer, which holds
// this core's hartid (core number), the index into cpus[].
static inline uint64 r_tp() {
    uint64 x;
    asm volatile("mv %0, tp" : "=r"(x));
    80200384:	01213023          	sd	s2,0(sp)
    80200388:	00020493          	mv	s1,tp
// cpu.c
struct cpu *mycpu();
struct cpu *getcpu(int i);

static inline struct proc *curr_proc() {
    push_off();
    8020038c:	00001097          	auipc	ra,0x1
    80200390:	5d8080e7          	jalr	1496(ra) # 80201964 <push_off>
    struct cpu* c = mycpu();
    80200394:	00004097          	auipc	ra,0x4
    80200398:	d58080e7          	jalr	-680(ra) # 802040ec <mycpu>
    struct proc* p = c->proc;
    8020039c:	00853903          	ld	s2,8(a0)
    return r_tp();
    802003a0:	0004849b          	sext.w	s1,s1
    pop_off();
    802003a4:	00001097          	auipc	ra,0x1
    802003a8:	634080e7          	jalr	1588(ra) # 802019d8 <pop_off>

#endif  // LOG_LEVEL_TRACE

static inline int __safe_pid() {
    struct proc *p = curr_proc();
    return p ? p->pid : -1;
    802003ac:	02090e63          	beqz	s2,802003e8 <console_init+0x130>
    802003b0:	02492703          	lw	a4,36(s2)
    assert(!uart_inited);
    802003b4:	00005897          	auipc	a7,0x5
    802003b8:	c4c88893          	addi	a7,a7,-948 # 80205000 <e_text>
    802003bc:	03500813          	li	a6,53
    802003c0:	00005797          	auipc	a5,0x5
    802003c4:	c5878793          	addi	a5,a5,-936 # 80205018 <e_text+0x18>
    802003c8:	00048693          	mv	a3,s1
    802003cc:	00005617          	auipc	a2,0x5
    802003d0:	c5c60613          	addi	a2,a2,-932 # 80205028 <e_text+0x28>
    802003d4:	01f00593          	li	a1,31
    802003d8:	00005517          	auipc	a0,0x5
    802003dc:	c5850513          	addi	a0,a0,-936 # 80205030 <e_text+0x30>
    802003e0:	00002097          	auipc	ra,0x2
    802003e4:	4a4080e7          	jalr	1188(ra) # 80202884 <__panic>
    802003e8:	fff00713          	li	a4,-1
    802003ec:	fc9ff06f          	j	802003b4 <console_init+0xfc>

00000000802003f0 <uart_intr>:
    } else {
        return -1;
    }
}

void uart_intr() {
    802003f0:	fa010113          	addi	sp,sp,-96
    802003f4:	04813823          	sd	s0,80(sp)
    802003f8:	01813823          	sd	s8,16(sp)
    802003fc:	04113c23          	sd	ra,88(sp)
    80200400:	06010413          	addi	s0,sp,96
    if (ReadReg(LSR) & 0x01) {
    80200404:	10000c37          	lui	s8,0x10000
    80200408:	005c4783          	lbu	a5,5(s8) # 10000005 <_entry-0x701ffffb>
    8020040c:	0017f793          	andi	a5,a5,1
    80200410:	1c078c63          	beqz	a5,802005e8 <uart_intr+0x1f8>
    80200414:	04913423          	sd	s1,72(sp)
    80200418:	03413823          	sd	s4,48(sp)
    8020041c:	03613023          	sd	s6,32(sp)
    80200420:	01913423          	sd	s9,8(sp)
    80200424:	05213023          	sd	s2,64(sp)
    80200428:	03313c23          	sd	s3,56(sp)
    8020042c:	03513423          	sd	s5,40(sp)
    80200430:	01713c23          	sd	s7,24(sp)
    80200434:	005c0c13          	addi	s8,s8,5
    80200438:	00009c97          	auipc	s9,0x9
    8020043c:	bc8c8c93          	addi	s9,s9,-1080 # 80209000 <uart_tx_lock>
    if (!uart_inited || panicked)  // when panicked, use SBI output
    80200440:	0001ea17          	auipc	s4,0x1e
    80200444:	f0ca0a13          	addi	s4,s4,-244 # 8021e34c <uart_inited>
    80200448:	0001eb17          	auipc	s6,0x1e
    8020044c:	f00b0b13          	addi	s6,s6,-256 # 8021e348 <panicked>
    asm volatile("csrrc %0, sstatus, %1" : "=r"(prev) : "r"(SSTATUS_SIE));
    80200450:	00200493          	li	s1,2
    80200454:	0380006f          	j	8020048c <uart_intr+0x9c>
    switch (c) {
    80200458:	01000793          	li	a5,16
    8020045c:	2af90663          	beq	s2,a5,80200708 <uart_intr+0x318>
    80200460:	01100793          	li	a5,17
    80200464:	2af91863          	bne	s2,a5,80200714 <uart_intr+0x324>
            print_kpgmgr();
    80200468:	00000097          	auipc	ra,0x0
    8020046c:	73c080e7          	jalr	1852(ra) # 80200ba4 <print_kpgmgr>
    release(&cons.lock);
    80200470:	00009517          	auipc	a0,0x9
    80200474:	bb050513          	addi	a0,a0,-1104 # 80209020 <cons>
    80200478:	00001097          	auipc	ra,0x1
    8020047c:	7c8080e7          	jalr	1992(ra) # 80201c40 <release>
    if (ReadReg(LSR) & 0x01) {
    80200480:	000c4783          	lbu	a5,0(s8)
    80200484:	0017f793          	andi	a5,a5,1
    80200488:	14078063          	beqz	a5,802005c8 <uart_intr+0x1d8>
        return ReadReg(RHR);
    8020048c:	100007b7          	lui	a5,0x10000
    80200490:	0007c903          	lbu	s2,0(a5) # 10000000 <_entry-0x70200000>
    acquire(&cons.lock);
    80200494:	00009517          	auipc	a0,0x9
    80200498:	b8c50513          	addi	a0,a0,-1140 # 80209020 <cons>
    8020049c:	00001097          	auipc	ra,0x1
    802004a0:	660080e7          	jalr	1632(ra) # 80201afc <acquire>
        return ReadReg(RHR);
    802004a4:	0ff97913          	zext.b	s2,s2
    switch (c) {
    802004a8:	01500793          	li	a5,21
    802004ac:	14f90863          	beq	s2,a5,802005fc <uart_intr+0x20c>
    802004b0:	fb27f4e3          	bgeu	a5,s2,80200458 <uart_intr+0x68>
    802004b4:	07f00793          	li	a5,127
    802004b8:	2cf91063          	bne	s2,a5,80200778 <uart_intr+0x388>
            if (cons.e != cons.w) {
    802004bc:	0c8ca783          	lw	a5,200(s9)
    802004c0:	0c4ca703          	lw	a4,196(s9)
    802004c4:	faf706e3          	beq	a4,a5,80200470 <uart_intr+0x80>
    if (!uart_inited || panicked)  // when panicked, use SBI output
    802004c8:	000a2703          	lw	a4,0(s4)
                cons.e--;
    802004cc:	fff7879b          	addiw	a5,a5,-1
    802004d0:	0cfca423          	sw	a5,200(s9)
    if (!uart_inited || panicked)  // when panicked, use SBI output
    802004d4:	30070663          	beqz	a4,802007e0 <uart_intr+0x3f0>
    802004d8:	000b2783          	lw	a5,0(s6)
    802004dc:	30079263          	bnez	a5,802007e0 <uart_intr+0x3f0>
    802004e0:	1004b773          	csrrc	a4,sstatus,s1
    while ((ReadReg(LSR) & LSR_TX_IDLE) == 0) MEMORY_FENCE();
    802004e4:	000c4783          	lbu	a5,0(s8)
    return (prev & SSTATUS_SIE) != 0;
    802004e8:	00277713          	andi	a4,a4,2
    802004ec:	0207f793          	andi	a5,a5,32
    802004f0:	00079a63          	bnez	a5,80200504 <uart_intr+0x114>
    802004f4:	0ff0000f          	fence
    802004f8:	000c4783          	lbu	a5,0(s8)
    802004fc:	0207f793          	andi	a5,a5,32
    80200500:	fe078ae3          	beqz	a5,802004f4 <uart_intr+0x104>
    MEMORY_FENCE();
    80200504:	0ff0000f          	fence
    WriteReg(THR, ch);
    80200508:	100007b7          	lui	a5,0x10000
    8020050c:	00800693          	li	a3,8
    80200510:	00d78023          	sb	a3,0(a5) # 10000000 <_entry-0x70200000>
    MEMORY_FENCE();
    80200514:	0ff0000f          	fence
    if (intr)
    80200518:	00070663          	beqz	a4,80200524 <uart_intr+0x134>
    asm volatile("csrrs x0, sstatus, %0" ::"r"(SSTATUS_SIE));
    8020051c:	00200793          	li	a5,2
    80200520:	1007a073          	csrs	sstatus,a5
    asm volatile("csrrc %0, sstatus, %1" : "=r"(prev) : "r"(SSTATUS_SIE));
    80200524:	1004b773          	csrrc	a4,sstatus,s1
    while ((ReadReg(LSR) & LSR_TX_IDLE) == 0) MEMORY_FENCE();
    80200528:	000c4783          	lbu	a5,0(s8)
    return (prev & SSTATUS_SIE) != 0;
    8020052c:	00277713          	andi	a4,a4,2
    80200530:	0207f793          	andi	a5,a5,32
    80200534:	00079a63          	bnez	a5,80200548 <uart_intr+0x158>
    80200538:	0ff0000f          	fence
    8020053c:	000c4783          	lbu	a5,0(s8)
    80200540:	0207f793          	andi	a5,a5,32
    80200544:	fe078ae3          	beqz	a5,80200538 <uart_intr+0x148>
    MEMORY_FENCE();
    80200548:	0ff0000f          	fence
    WriteReg(THR, ch);
    8020054c:	100007b7          	lui	a5,0x10000
    80200550:	02000693          	li	a3,32
    80200554:	00d78023          	sb	a3,0(a5) # 10000000 <_entry-0x70200000>
    MEMORY_FENCE();
    80200558:	0ff0000f          	fence
    if (intr)
    8020055c:	00070663          	beqz	a4,80200568 <uart_intr+0x178>
    asm volatile("csrrs x0, sstatus, %0" ::"r"(SSTATUS_SIE));
    80200560:	00200793          	li	a5,2
    80200564:	1007a073          	csrs	sstatus,a5
    asm volatile("csrrc %0, sstatus, %1" : "=r"(prev) : "r"(SSTATUS_SIE));
    80200568:	1004b773          	csrrc	a4,sstatus,s1
    while ((ReadReg(LSR) & LSR_TX_IDLE) == 0) MEMORY_FENCE();
    8020056c:	000c4783          	lbu	a5,0(s8)
    return (prev & SSTATUS_SIE) != 0;
    80200570:	00277713          	andi	a4,a4,2
    80200574:	0207f793          	andi	a5,a5,32
    80200578:	00079a63          	bnez	a5,8020058c <uart_intr+0x19c>
    8020057c:	0ff0000f          	fence
    80200580:	000c4783          	lbu	a5,0(s8)
    80200584:	0207f793          	andi	a5,a5,32
    80200588:	fe078ae3          	beqz	a5,8020057c <uart_intr+0x18c>
    MEMORY_FENCE();
    8020058c:	0ff0000f          	fence
    WriteReg(THR, ch);
    80200590:	100007b7          	lui	a5,0x10000
    80200594:	00800693          	li	a3,8
    80200598:	00d78023          	sb	a3,0(a5) # 10000000 <_entry-0x70200000>
    MEMORY_FENCE();
    8020059c:	0ff0000f          	fence
    if (intr)
    802005a0:	ec0708e3          	beqz	a4,80200470 <uart_intr+0x80>
    asm volatile("csrrs x0, sstatus, %0" ::"r"(SSTATUS_SIE));
    802005a4:	00200793          	li	a5,2
    802005a8:	1007a073          	csrs	sstatus,a5
    release(&cons.lock);
    802005ac:	00009517          	auipc	a0,0x9
    802005b0:	a7450513          	addi	a0,a0,-1420 # 80209020 <cons>
    802005b4:	00001097          	auipc	ra,0x1
    802005b8:	68c080e7          	jalr	1676(ra) # 80201c40 <release>
    if (ReadReg(LSR) & 0x01) {
    802005bc:	000c4783          	lbu	a5,0(s8)
    802005c0:	0017f793          	andi	a5,a5,1
    802005c4:	ec0794e3          	bnez	a5,8020048c <uart_intr+0x9c>
    802005c8:	04813483          	ld	s1,72(sp)
    802005cc:	04013903          	ld	s2,64(sp)
    802005d0:	03813983          	ld	s3,56(sp)
    802005d4:	03013a03          	ld	s4,48(sp)
    802005d8:	02813a83          	ld	s5,40(sp)
    802005dc:	02013b03          	ld	s6,32(sp)
    802005e0:	01813b83          	ld	s7,24(sp)
    802005e4:	00813c83          	ld	s9,8(sp)
        if (c == -1)
            break;
        // infof("uart: %c", c);
        consintr(c);
    }
}
    802005e8:	05813083          	ld	ra,88(sp)
    802005ec:	05013403          	ld	s0,80(sp)
    802005f0:	01013c03          	ld	s8,16(sp)
    802005f4:	06010113          	addi	sp,sp,96
    802005f8:	00008067          	ret
            while (cons.e != cons.w && cons.buf[(cons.e - 1) % INPUT_BUF_SIZE] != '\n') {
    802005fc:	0c8ca783          	lw	a5,200(s9)
    80200600:	0c4ca703          	lw	a4,196(s9)
    80200604:	e6f706e3          	beq	a4,a5,80200470 <uart_intr+0x80>
    80200608:	00a00913          	li	s2,10
    WriteReg(THR, ch);
    8020060c:	100009b7          	lui	s3,0x10000
    80200610:	00800a93          	li	s5,8
    80200614:	02000b93          	li	s7,32
            while (cons.e != cons.w && cons.buf[(cons.e - 1) % INPUT_BUF_SIZE] != '\n') {
    80200618:	fff7879b          	addiw	a5,a5,-1
    8020061c:	07f7f713          	andi	a4,a5,127
    80200620:	00ec8733          	add	a4,s9,a4
    80200624:	04074703          	lbu	a4,64(a4)
    80200628:	e52704e3          	beq	a4,s2,80200470 <uart_intr+0x80>
    if (!uart_inited || panicked)  // when panicked, use SBI output
    8020062c:	000a2703          	lw	a4,0(s4)
                cons.e--;
    80200630:	0cfca423          	sw	a5,200(s9)
    if (!uart_inited || panicked)  // when panicked, use SBI output
    80200634:	0c070263          	beqz	a4,802006f8 <uart_intr+0x308>
    80200638:	000b2783          	lw	a5,0(s6)
    8020063c:	0a079e63          	bnez	a5,802006f8 <uart_intr+0x308>
    asm volatile("csrrc %0, sstatus, %1" : "=r"(prev) : "r"(SSTATUS_SIE));
    80200640:	1004b773          	csrrc	a4,sstatus,s1
    while ((ReadReg(LSR) & LSR_TX_IDLE) == 0) MEMORY_FENCE();
    80200644:	000c4783          	lbu	a5,0(s8)
    return (prev & SSTATUS_SIE) != 0;
    80200648:	00277713          	andi	a4,a4,2
    8020064c:	0207f793          	andi	a5,a5,32
    80200650:	00079a63          	bnez	a5,80200664 <uart_intr+0x274>
    80200654:	0ff0000f          	fence
    80200658:	000c4783          	lbu	a5,0(s8)
    8020065c:	0207f793          	andi	a5,a5,32
    80200660:	fe078ae3          	beqz	a5,80200654 <uart_intr+0x264>
    MEMORY_FENCE();
    80200664:	0ff0000f          	fence
    WriteReg(THR, ch);
    80200668:	01598023          	sb	s5,0(s3) # 10000000 <_entry-0x70200000>
    MEMORY_FENCE();
    8020066c:	0ff0000f          	fence
    if (intr)
    80200670:	00070463          	beqz	a4,80200678 <uart_intr+0x288>
    asm volatile("csrrs x0, sstatus, %0" ::"r"(SSTATUS_SIE));
    80200674:	1004a073          	csrs	sstatus,s1
    asm volatile("csrrc %0, sstatus, %1" : "=r"(prev) : "r"(SSTATUS_SIE));
    80200678:	1004b773          	csrrc	a4,sstatus,s1
    while ((ReadReg(LSR) & LSR_TX_IDLE) == 0) MEMORY_FENCE();
    8020067c:	000c4783          	lbu	a5,0(s8)
    return (prev & SSTATUS_SIE) != 0;
    80200680:	00277713          	andi	a4,a4,2
    80200684:	0207f793          	andi	a5,a5,32
    80200688:	00079a63          	bnez	a5,8020069c <uart_intr+0x2ac>
    8020068c:	0ff0000f          	fence
    80200690:	000c4783          	lbu	a5,0(s8)
    80200694:	0207f793          	andi	a5,a5,32
    80200698:	fe078ae3          	beqz	a5,8020068c <uart_intr+0x29c>
    MEMORY_FENCE();
    8020069c:	0ff0000f          	fence
    WriteReg(THR, ch);
    802006a0:	01798023          	sb	s7,0(s3)
    MEMORY_FENCE();
    802006a4:	0ff0000f          	fence
    if (intr)
    802006a8:	00070463          	beqz	a4,802006b0 <uart_intr+0x2c0>
    asm volatile("csrrs x0, sstatus, %0" ::"r"(SSTATUS_SIE));
    802006ac:	1004a073          	csrs	sstatus,s1
    asm volatile("csrrc %0, sstatus, %1" : "=r"(prev) : "r"(SSTATUS_SIE));
    802006b0:	1004b773          	csrrc	a4,sstatus,s1
    while ((ReadReg(LSR) & LSR_TX_IDLE) == 0) MEMORY_FENCE();
    802006b4:	000c4783          	lbu	a5,0(s8)
    return (prev & SSTATUS_SIE) != 0;
    802006b8:	00277713          	andi	a4,a4,2
    802006bc:	0207f793          	andi	a5,a5,32
    802006c0:	00079a63          	bnez	a5,802006d4 <uart_intr+0x2e4>
    802006c4:	0ff0000f          	fence
    802006c8:	000c4783          	lbu	a5,0(s8)
    802006cc:	0207f793          	andi	a5,a5,32
    802006d0:	fe078ae3          	beqz	a5,802006c4 <uart_intr+0x2d4>
    MEMORY_FENCE();
    802006d4:	0ff0000f          	fence
    WriteReg(THR, ch);
    802006d8:	01598023          	sb	s5,0(s3)
    MEMORY_FENCE();
    802006dc:	0ff0000f          	fence
    if (intr)
    802006e0:	00070463          	beqz	a4,802006e8 <uart_intr+0x2f8>
    asm volatile("csrrs x0, sstatus, %0" ::"r"(SSTATUS_SIE));
    802006e4:	1004a073          	csrs	sstatus,s1
            while (cons.e != cons.w && cons.buf[(cons.e - 1) % INPUT_BUF_SIZE] != '\n') {
    802006e8:	0c8ca783          	lw	a5,200(s9)
    802006ec:	0c4ca703          	lw	a4,196(s9)
    802006f0:	f2f714e3          	bne	a4,a5,80200618 <uart_intr+0x228>
    802006f4:	d7dff06f          	j	80200470 <uart_intr+0x80>
        sbi_putchar(c);
    802006f8:	10000513          	li	a0,256
    802006fc:	00003097          	auipc	ra,0x3
    80200700:	148080e7          	jalr	328(ra) # 80203844 <sbi_putchar>
    80200704:	fe5ff06f          	j	802006e8 <uart_intr+0x2f8>
            print_procs();
    80200708:	00000097          	auipc	ra,0x0
    8020070c:	388080e7          	jalr	904(ra) # 80200a90 <print_procs>
            break;
    80200710:	d61ff06f          	j	80200470 <uart_intr+0x80>
        return ReadReg(RHR);
    80200714:	0009099b          	sext.w	s3,s2
            if (c != 0 && cons.e - cons.r < INPUT_BUF_SIZE) {
    80200718:	d4090ce3          	beqz	s2,80200470 <uart_intr+0x80>
    8020071c:	0c8ca783          	lw	a5,200(s9)
    80200720:	0c0ca683          	lw	a3,192(s9)
    80200724:	07f00713          	li	a4,127
    80200728:	40d787bb          	subw	a5,a5,a3
    8020072c:	d4f762e3          	bltu	a4,a5,80200470 <uart_intr+0x80>
                c = (c == '\r') ? '\n' : c;
    80200730:	00d00793          	li	a5,13
    80200734:	0af99e63          	bne	s3,a5,802007f0 <uart_intr+0x400>
                consputc(c);
    80200738:	00a00513          	li	a0,10
    8020073c:	00000097          	auipc	ra,0x0
    80200740:	9fc080e7          	jalr	-1540(ra) # 80200138 <consputc>
                cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80200744:	0c8ca783          	lw	a5,200(s9)
    80200748:	07f7f693          	andi	a3,a5,127
    8020074c:	0017871b          	addiw	a4,a5,1
    80200750:	00dc86b3          	add	a3,s9,a3
    80200754:	00a00793          	li	a5,10
    80200758:	0ceca423          	sw	a4,200(s9)
    8020075c:	04f68023          	sb	a5,64(a3)
                    wakeup(&cons);
    80200760:	00009517          	auipc	a0,0x9
    80200764:	8c050513          	addi	a0,a0,-1856 # 80209020 <cons>
                    cons.w = cons.e;
    80200768:	0ceca223          	sw	a4,196(s9)
                    wakeup(&cons);
    8020076c:	00003097          	auipc	ra,0x3
    80200770:	9f4080e7          	jalr	-1548(ra) # 80203160 <wakeup>
    80200774:	cfdff06f          	j	80200470 <uart_intr+0x80>
            if (c != 0 && cons.e - cons.r < INPUT_BUF_SIZE) {
    80200778:	0c8ca703          	lw	a4,200(s9)
    8020077c:	0c0ca683          	lw	a3,192(s9)
    80200780:	40d7073b          	subw	a4,a4,a3
    80200784:	cee7e6e3          	bltu	a5,a4,80200470 <uart_intr+0x80>
        return ReadReg(RHR);
    80200788:	0009099b          	sext.w	s3,s2
                consputc(c);
    8020078c:	00098513          	mv	a0,s3
    80200790:	00000097          	auipc	ra,0x0
    80200794:	9a8080e7          	jalr	-1624(ra) # 80200138 <consputc>
                cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80200798:	0c8ca783          	lw	a5,200(s9)
    8020079c:	07f7f693          	andi	a3,a5,127
    802007a0:	0017871b          	addiw	a4,a5,1
    802007a4:	00dc86b3          	add	a3,s9,a3
    802007a8:	0ceca423          	sw	a4,200(s9)
    802007ac:	05268023          	sb	s2,64(a3)
                if (c == '\n' || c == C('D') || cons.e - cons.r == INPUT_BUF_SIZE) {
    802007b0:	00400793          	li	a5,4
    802007b4:	faf986e3          	beq	s3,a5,80200760 <uart_intr+0x370>
    802007b8:	0c0ca783          	lw	a5,192(s9)
    802007bc:	08000693          	li	a3,128
    802007c0:	40f707bb          	subw	a5,a4,a5
    802007c4:	cad796e3          	bne	a5,a3,80200470 <uart_intr+0x80>
                    wakeup(&cons);
    802007c8:	00009517          	auipc	a0,0x9
    802007cc:	85850513          	addi	a0,a0,-1960 # 80209020 <cons>
                    cons.w = cons.e;
    802007d0:	0ceca223          	sw	a4,196(s9)
                    wakeup(&cons);
    802007d4:	00003097          	auipc	ra,0x3
    802007d8:	98c080e7          	jalr	-1652(ra) # 80203160 <wakeup>
    802007dc:	c95ff06f          	j	80200470 <uart_intr+0x80>
        sbi_putchar(c);
    802007e0:	10000513          	li	a0,256
    802007e4:	00003097          	auipc	ra,0x3
    802007e8:	060080e7          	jalr	96(ra) # 80203844 <sbi_putchar>
    802007ec:	c85ff06f          	j	80200470 <uart_intr+0x80>
                consputc(c);
    802007f0:	00098513          	mv	a0,s3
    802007f4:	00000097          	auipc	ra,0x0
    802007f8:	944080e7          	jalr	-1724(ra) # 80200138 <consputc>
                cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    802007fc:	0c8ca703          	lw	a4,200(s9)
                if (c == '\n' || c == C('D') || cons.e - cons.r == INPUT_BUF_SIZE) {
    80200800:	00a00693          	li	a3,10
                cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80200804:	07f77793          	andi	a5,a4,127
    80200808:	00fc87b3          	add	a5,s9,a5
    8020080c:	0017071b          	addiw	a4,a4,1
    80200810:	0ceca423          	sw	a4,200(s9)
    80200814:	05278023          	sb	s2,64(a5)
                if (c == '\n' || c == C('D') || cons.e - cons.r == INPUT_BUF_SIZE) {
    80200818:	f8d99ce3          	bne	s3,a3,802007b0 <uart_intr+0x3c0>
    8020081c:	f45ff06f          	j	80200760 <uart_intr+0x370>

0000000080200820 <print_trapframe>:
#include "debug.h"

#include "defs.h"

void print_trapframe(struct trapframe *tf) {
    80200820:	fe010113          	addi	sp,sp,-32
    80200824:	00113c23          	sd	ra,24(sp)
    80200828:	00813823          	sd	s0,16(sp)
    8020082c:	00913423          	sd	s1,8(sp)
    80200830:	02010413          	addi	s0,sp,32
    80200834:	00050493          	mv	s1,a0
    printf("trapframe at %p\n", tf);
    80200838:	00050593          	mv	a1,a0
    8020083c:	00005517          	auipc	a0,0x5
    80200840:	83c50513          	addi	a0,a0,-1988 # 80205078 <e_text+0x78>
    80200844:	00002097          	auipc	ra,0x2
    80200848:	340080e7          	jalr	832(ra) # 80202b84 <printf>
    printf("ra: %p  sp: %p  gp: %p  tp: %p\n", tf->ra, tf->sp, tf->gp, tf->tp);
    8020084c:	0404b703          	ld	a4,64(s1)
    80200850:	0384b683          	ld	a3,56(s1)
    80200854:	0304b603          	ld	a2,48(s1)
    80200858:	0284b583          	ld	a1,40(s1)
    8020085c:	00005517          	auipc	a0,0x5
    80200860:	83450513          	addi	a0,a0,-1996 # 80205090 <e_text+0x90>
    80200864:	00002097          	auipc	ra,0x2
    80200868:	320080e7          	jalr	800(ra) # 80202b84 <printf>
    printf("t0: %p  t1: %p  t2: %p  s0: %p\n", tf->t0, tf->t1, tf->t2, tf->s0);
    8020086c:	0604b703          	ld	a4,96(s1)
    80200870:	0584b683          	ld	a3,88(s1)
    80200874:	0504b603          	ld	a2,80(s1)
    80200878:	0484b583          	ld	a1,72(s1)
    8020087c:	00005517          	auipc	a0,0x5
    80200880:	83450513          	addi	a0,a0,-1996 # 802050b0 <e_text+0xb0>
    80200884:	00002097          	auipc	ra,0x2
    80200888:	300080e7          	jalr	768(ra) # 80202b84 <printf>
    printf("s1: %p  a0: %p  a1: %p  a2: %p\n", tf->s1, tf->a0, tf->a1, tf->a2);
    8020088c:	0804b703          	ld	a4,128(s1)
    80200890:	0784b683          	ld	a3,120(s1)
    80200894:	0704b603          	ld	a2,112(s1)
    80200898:	0684b583          	ld	a1,104(s1)
    8020089c:	00005517          	auipc	a0,0x5
    802008a0:	83450513          	addi	a0,a0,-1996 # 802050d0 <e_text+0xd0>
    802008a4:	00002097          	auipc	ra,0x2
    802008a8:	2e0080e7          	jalr	736(ra) # 80202b84 <printf>
    printf("a3: %p  a4: %p  a5: %p  a6: %p\n", tf->a3, tf->a4, tf->a5, tf->a6);
    802008ac:	0a04b703          	ld	a4,160(s1)
    802008b0:	0984b683          	ld	a3,152(s1)
    802008b4:	0904b603          	ld	a2,144(s1)
    802008b8:	0884b583          	ld	a1,136(s1)
    802008bc:	00005517          	auipc	a0,0x5
    802008c0:	83450513          	addi	a0,a0,-1996 # 802050f0 <e_text+0xf0>
    802008c4:	00002097          	auipc	ra,0x2
    802008c8:	2c0080e7          	jalr	704(ra) # 80202b84 <printf>
    printf("a7: %p  s2: %p  s3: %p  s4: %p\n", tf->a7, tf->s2, tf->s3, tf->s4);
    802008cc:	0c04b703          	ld	a4,192(s1)
    802008d0:	0b84b683          	ld	a3,184(s1)
    802008d4:	0b04b603          	ld	a2,176(s1)
    802008d8:	0a84b583          	ld	a1,168(s1)
    802008dc:	00005517          	auipc	a0,0x5
    802008e0:	83450513          	addi	a0,a0,-1996 # 80205110 <e_text+0x110>
    802008e4:	00002097          	auipc	ra,0x2
    802008e8:	2a0080e7          	jalr	672(ra) # 80202b84 <printf>
    printf("s5: %p  s6: %p  s7: %p  s8: %p\n", tf->s5, tf->s6, tf->s7, tf->s8);
    802008ec:	0e04b703          	ld	a4,224(s1)
    802008f0:	0d84b683          	ld	a3,216(s1)
    802008f4:	0d04b603          	ld	a2,208(s1)
    802008f8:	0c84b583          	ld	a1,200(s1)
    802008fc:	00005517          	auipc	a0,0x5
    80200900:	83450513          	addi	a0,a0,-1996 # 80205130 <e_text+0x130>
    80200904:	00002097          	auipc	ra,0x2
    80200908:	280080e7          	jalr	640(ra) # 80202b84 <printf>
    printf("s9: %p s10: %p s11: %p  t3: %p\n", tf->s9, tf->s10, tf->s11, tf->t3);
    8020090c:	0f84b683          	ld	a3,248(s1)
    80200910:	0f04b603          	ld	a2,240(s1)
    80200914:	0e84b583          	ld	a1,232(s1)
    80200918:	1004b703          	ld	a4,256(s1)
    8020091c:	00005517          	auipc	a0,0x5
    80200920:	83450513          	addi	a0,a0,-1996 # 80205150 <e_text+0x150>
    80200924:	00002097          	auipc	ra,0x2
    80200928:	260080e7          	jalr	608(ra) # 80202b84 <printf>
    printf("t4: %p  t5: %p  t6: %p  \n\n", tf->t4, tf->t5, tf->t6);
}
    8020092c:	01013403          	ld	s0,16(sp)
    printf("t4: %p  t5: %p  t6: %p  \n\n", tf->t4, tf->t5, tf->t6);
    80200930:	1184b683          	ld	a3,280(s1)
    80200934:	1104b603          	ld	a2,272(s1)
    80200938:	1084b583          	ld	a1,264(s1)
}
    8020093c:	01813083          	ld	ra,24(sp)
    80200940:	00813483          	ld	s1,8(sp)
    printf("t4: %p  t5: %p  t6: %p  \n\n", tf->t4, tf->t5, tf->t6);
    80200944:	00005517          	auipc	a0,0x5
    80200948:	82c50513          	addi	a0,a0,-2004 # 80205170 <e_text+0x170>
}
    8020094c:	02010113          	addi	sp,sp,32
    printf("t4: %p  t5: %p  t6: %p  \n\n", tf->t4, tf->t5, tf->t6);
    80200950:	00002317          	auipc	t1,0x2
    80200954:	23430067          	jr	564(t1) # 80202b84 <printf>

0000000080200958 <print_ktrapframe>:

void print_ktrapframe(struct ktrapframe *tf) {
    80200958:	fe010113          	addi	sp,sp,-32
    8020095c:	00113c23          	sd	ra,24(sp)
    80200960:	00813823          	sd	s0,16(sp)
    80200964:	00913423          	sd	s1,8(sp)
    80200968:	02010413          	addi	s0,sp,32
    8020096c:	00050493          	mv	s1,a0
    printf("kernel trapframe at %p\n", tf);
    80200970:	00050593          	mv	a1,a0
    80200974:	00005517          	auipc	a0,0x5
    80200978:	81c50513          	addi	a0,a0,-2020 # 80205190 <e_text+0x190>
    8020097c:	00002097          	auipc	ra,0x2
    80200980:	208080e7          	jalr	520(ra) # 80202b84 <printf>
    printf("ra: %p   sp: %p   gp: %p  tp: %p\n", tf->ra, tf->sp, tf->gp, tf->tp);
    80200984:	0204b703          	ld	a4,32(s1)
    80200988:	0184b683          	ld	a3,24(s1)
    8020098c:	0104b603          	ld	a2,16(s1)
    80200990:	0084b583          	ld	a1,8(s1)
    80200994:	00005517          	auipc	a0,0x5
    80200998:	81450513          	addi	a0,a0,-2028 # 802051a8 <e_text+0x1a8>
    8020099c:	00002097          	auipc	ra,0x2
    802009a0:	1e8080e7          	jalr	488(ra) # 80202b84 <printf>
    printf("t0: %p   t1: %p   t2: %p  s0: %p\n", tf->t0, tf->t1, tf->t2, tf->s0);
    802009a4:	0404b703          	ld	a4,64(s1)
    802009a8:	0384b683          	ld	a3,56(s1)
    802009ac:	0304b603          	ld	a2,48(s1)
    802009b0:	0284b583          	ld	a1,40(s1)
    802009b4:	00005517          	auipc	a0,0x5
    802009b8:	81c50513          	addi	a0,a0,-2020 # 802051d0 <e_text+0x1d0>
    802009bc:	00002097          	auipc	ra,0x2
    802009c0:	1c8080e7          	jalr	456(ra) # 80202b84 <printf>
    printf("s1: %p   a0: %p   a1: %p  a2: %p\n", tf->s1, tf->a0, tf->a1, tf->a2);
    802009c4:	0604b703          	ld	a4,96(s1)
    802009c8:	0584b683          	ld	a3,88(s1)
    802009cc:	0504b603          	ld	a2,80(s1)
    802009d0:	0484b583          	ld	a1,72(s1)
    802009d4:	00005517          	auipc	a0,0x5
    802009d8:	82450513          	addi	a0,a0,-2012 # 802051f8 <e_text+0x1f8>
    802009dc:	00002097          	auipc	ra,0x2
    802009e0:	1a8080e7          	jalr	424(ra) # 80202b84 <printf>
    printf("a3: %p   a4: %p   a5: %p  a6: %p\n", tf->a3, tf->a4, tf->a5, tf->a6);
    802009e4:	0804b703          	ld	a4,128(s1)
    802009e8:	0784b683          	ld	a3,120(s1)
    802009ec:	0704b603          	ld	a2,112(s1)
    802009f0:	0684b583          	ld	a1,104(s1)
    802009f4:	00005517          	auipc	a0,0x5
    802009f8:	82c50513          	addi	a0,a0,-2004 # 80205220 <e_text+0x220>
    802009fc:	00002097          	auipc	ra,0x2
    80200a00:	188080e7          	jalr	392(ra) # 80202b84 <printf>
    printf("a7: %p   s2: %p   s3: %p  s4: %p\n", tf->a7, tf->s2, tf->s3, tf->s4);
    80200a04:	0a04b703          	ld	a4,160(s1)
    80200a08:	0984b683          	ld	a3,152(s1)
    80200a0c:	0904b603          	ld	a2,144(s1)
    80200a10:	0884b583          	ld	a1,136(s1)
    80200a14:	00005517          	auipc	a0,0x5
    80200a18:	83450513          	addi	a0,a0,-1996 # 80205248 <e_text+0x248>
    80200a1c:	00002097          	auipc	ra,0x2
    80200a20:	168080e7          	jalr	360(ra) # 80202b84 <printf>
    printf("s5: %p   s6: %p   s7: %p  s8: %p\n", tf->s5, tf->s6, tf->s7, tf->s8);
    80200a24:	0c04b703          	ld	a4,192(s1)
    80200a28:	0b84b683          	ld	a3,184(s1)
    80200a2c:	0b04b603          	ld	a2,176(s1)
    80200a30:	0a84b583          	ld	a1,168(s1)
    80200a34:	00005517          	auipc	a0,0x5
    80200a38:	83c50513          	addi	a0,a0,-1988 # 80205270 <e_text+0x270>
    80200a3c:	00002097          	auipc	ra,0x2
    80200a40:	148080e7          	jalr	328(ra) # 80202b84 <printf>
    printf("s9: %p  s10: %p  s11: %p  t3: %p\n", tf->s9, tf->s10, tf->s11, tf->t3);
    80200a44:	0d84b683          	ld	a3,216(s1)
    80200a48:	0d04b603          	ld	a2,208(s1)
    80200a4c:	0c84b583          	ld	a1,200(s1)
    80200a50:	0e04b703          	ld	a4,224(s1)
    80200a54:	00005517          	auipc	a0,0x5
    80200a58:	84450513          	addi	a0,a0,-1980 # 80205298 <e_text+0x298>
    80200a5c:	00002097          	auipc	ra,0x2
    80200a60:	128080e7          	jalr	296(ra) # 80202b84 <printf>
    printf("t4: %p   t5: %p   t6: %p  \n\n", tf->t4, tf->t5, tf->t6);
}
    80200a64:	01013403          	ld	s0,16(sp)
    printf("t4: %p   t5: %p   t6: %p  \n\n", tf->t4, tf->t5, tf->t6);
    80200a68:	0f84b683          	ld	a3,248(s1)
    80200a6c:	0f04b603          	ld	a2,240(s1)
    80200a70:	0e84b583          	ld	a1,232(s1)
}
    80200a74:	01813083          	ld	ra,24(sp)
    80200a78:	00813483          	ld	s1,8(sp)
    printf("t4: %p   t5: %p   t6: %p  \n\n", tf->t4, tf->t5, tf->t6);
    80200a7c:	00005517          	auipc	a0,0x5
    80200a80:	84450513          	addi	a0,a0,-1980 # 802052c0 <e_text+0x2c0>
}
    80200a84:	02010113          	addi	sp,sp,32
    printf("t4: %p   t5: %p   t6: %p  \n\n", tf->t4, tf->t5, tf->t6);
    80200a88:	00002317          	auipc	t1,0x2
    80200a8c:	0fc30067          	jr	252(t1) # 80202b84 <printf>

0000000080200a90 <print_procs>:

void print_procs() {
    80200a90:	fa010113          	addi	sp,sp,-96
    80200a94:	04813823          	sd	s0,80(sp)
    80200a98:	05213023          	sd	s2,64(sp)
    80200a9c:	03313c23          	sd	s3,56(sp)
    80200aa0:	03413823          	sd	s4,48(sp)
    80200aa4:	03513423          	sd	s5,40(sp)
    80200aa8:	03613023          	sd	s6,32(sp)
    80200aac:	01713c23          	sd	s7,24(sp)
    80200ab0:	01813823          	sd	s8,16(sp)
    80200ab4:	01913423          	sd	s9,8(sp)
    80200ab8:	04113c23          	sd	ra,88(sp)
    80200abc:	04913423          	sd	s1,72(sp)
    80200ac0:	06010413          	addi	s0,sp,96
    80200ac4:	0001a997          	auipc	s3,0x1a
    80200ac8:	5d498993          	addi	s3,s3,1492 # 8021b098 <pool>
    extern struct proc *pool[];

    for (int i = 0; i < NPROC; i++) {
    80200acc:	00000913          	li	s2,0
        struct proc *p = pool[i];
        if (p->state == UNUSED)
            continue;
        printf("proc %d: %p\n", i, p);
    80200ad0:	00005a97          	auipc	s5,0x5
    80200ad4:	810a8a93          	addi	s5,s5,-2032 # 802052e0 <e_text+0x2e0>
        printf("  pid: %d, state: %d\n", p->pid, p->state);
    80200ad8:	00005c97          	auipc	s9,0x5
    80200adc:	818c8c93          	addi	s9,s9,-2024 # 802052f0 <e_text+0x2f0>
//        printf("  mm: %p\n", p->mm);
        printf("  parent: %p", p->parent);
    80200ae0:	00005c17          	auipc	s8,0x5
    80200ae4:	828c0c13          	addi	s8,s8,-2008 # 80205308 <e_text+0x308>
        if (p->parent)
            printf(" pid: %d", p->parent->pid);
        printf("\n");
    80200ae8:	00005b97          	auipc	s7,0x5
    80200aec:	840b8b93          	addi	s7,s7,-1984 # 80205328 <e_text+0x328>
            printf(" pid: %d", p->parent->pid);
    80200af0:	00005b17          	auipc	s6,0x5
    80200af4:	828b0b13          	addi	s6,s6,-2008 # 80205318 <e_text+0x318>
    for (int i = 0; i < NPROC; i++) {
    80200af8:	20000a13          	li	s4,512
        struct proc *p = pool[i];
    80200afc:	0009b483          	ld	s1,0(s3)
        printf("proc %d: %p\n", i, p);
    80200b00:	00090593          	mv	a1,s2
    80200b04:	000a8513          	mv	a0,s5
        if (p->state == UNUSED)
    80200b08:	0204a783          	lw	a5,32(s1)
        printf("proc %d: %p\n", i, p);
    80200b0c:	00048613          	mv	a2,s1
        if (p->state == UNUSED)
    80200b10:	04078a63          	beqz	a5,80200b64 <print_procs+0xd4>
        printf("proc %d: %p\n", i, p);
    80200b14:	00002097          	auipc	ra,0x2
    80200b18:	070080e7          	jalr	112(ra) # 80202b84 <printf>
        printf("  pid: %d, state: %d\n", p->pid, p->state);
    80200b1c:	0204a603          	lw	a2,32(s1)
    80200b20:	0244a583          	lw	a1,36(s1)
    80200b24:	000c8513          	mv	a0,s9
    80200b28:	00002097          	auipc	ra,0x2
    80200b2c:	05c080e7          	jalr	92(ra) # 80202b84 <printf>
        printf("  parent: %p", p->parent);
    80200b30:	0404b583          	ld	a1,64(s1)
    80200b34:	000c0513          	mv	a0,s8
    80200b38:	00002097          	auipc	ra,0x2
    80200b3c:	04c080e7          	jalr	76(ra) # 80202b84 <printf>
        if (p->parent)
    80200b40:	0404b783          	ld	a5,64(s1)
            printf(" pid: %d", p->parent->pid);
    80200b44:	000b0513          	mv	a0,s6
        if (p->parent)
    80200b48:	00078863          	beqz	a5,80200b58 <print_procs+0xc8>
            printf(" pid: %d", p->parent->pid);
    80200b4c:	0247a583          	lw	a1,36(a5)
    80200b50:	00002097          	auipc	ra,0x2
    80200b54:	034080e7          	jalr	52(ra) # 80202b84 <printf>
        printf("\n");
    80200b58:	000b8513          	mv	a0,s7
    80200b5c:	00002097          	auipc	ra,0x2
    80200b60:	028080e7          	jalr	40(ra) # 80202b84 <printf>
    for (int i = 0; i < NPROC; i++) {
    80200b64:	0019091b          	addiw	s2,s2,1
    80200b68:	00898993          	addi	s3,s3,8
    80200b6c:	f94918e3          	bne	s2,s4,80200afc <print_procs+0x6c>
    }
}
    80200b70:	05813083          	ld	ra,88(sp)
    80200b74:	05013403          	ld	s0,80(sp)
    80200b78:	04813483          	ld	s1,72(sp)
    80200b7c:	04013903          	ld	s2,64(sp)
    80200b80:	03813983          	ld	s3,56(sp)
    80200b84:	03013a03          	ld	s4,48(sp)
    80200b88:	02813a83          	ld	s5,40(sp)
    80200b8c:	02013b03          	ld	s6,32(sp)
    80200b90:	01813b83          	ld	s7,24(sp)
    80200b94:	01013c03          	ld	s8,16(sp)
    80200b98:	00813c83          	ld	s9,8(sp)
    80200b9c:	06010113          	addi	sp,sp,96
    80200ba0:	00008067          	ret

0000000080200ba4 <print_kpgmgr>:
void print_kpgmgr() {
    80200ba4:	ff010113          	addi	sp,sp,-16
    80200ba8:	00813423          	sd	s0,8(sp)
    80200bac:	01010413          	addi	s0,sp,16
    extern int64 freepages_count;
    printf("freepages_count: %d\n", freepages_count);
}
    80200bb0:	00813403          	ld	s0,8(sp)
    printf("freepages_count: %d\n", freepages_count);
    80200bb4:	0001d597          	auipc	a1,0x1d
    80200bb8:	79c5b583          	ld	a1,1948(a1) # 8021e350 <freepages_count>
    80200bbc:	00004517          	auipc	a0,0x4
    80200bc0:	77450513          	addi	a0,a0,1908 # 80205330 <e_text+0x330>
}
    80200bc4:	01010113          	addi	sp,sp,16
    printf("freepages_count: %d\n", freepages_count);
    80200bc8:	00002317          	auipc	t1,0x2
    80200bcc:	fbc30067          	jr	-68(t1) # 80202b84 <printf>

0000000080200bd0 <print_sysregs>:

void print_sysregs(int explain) {
    80200bd0:	fb010113          	addi	sp,sp,-80
    80200bd4:	04813023          	sd	s0,64(sp)
    80200bd8:	03413023          	sd	s4,32(sp)
    80200bdc:	04113423          	sd	ra,72(sp)
    80200be0:	02913c23          	sd	s1,56(sp)
    80200be4:	03213823          	sd	s2,48(sp)
    80200be8:	03313423          	sd	s3,40(sp)
    80200bec:	01513c23          	sd	s5,24(sp)
    80200bf0:	01613823          	sd	s6,16(sp)
    80200bf4:	01713423          	sd	s7,8(sp)
    80200bf8:	01813023          	sd	s8,0(sp)
    80200bfc:	05010413          	addi	s0,sp,80
    80200c00:	00050a13          	mv	s4,a0
    asm volatile("csrr %0, sstatus" : "=r"(x));
    80200c04:	100024f3          	csrr	s1,sstatus
    asm volatile("csrr %0, scause" : "=r"(x));
    80200c08:	14202af3          	csrr	s5,scause
    asm volatile("csrr %0, sie" : "=r"(x));
    80200c0c:	10402973          	csrr	s2,sie
    asm volatile("csrr %0, sepc" : "=r"(x));
    80200c10:	14102c73          	csrr	s8,sepc
    asm volatile("csrr %0, stval" : "=r"(x));
    80200c14:	14302bf3          	csrr	s7,stval
    asm volatile("csrr %0, sip" : "=r"(x));
    80200c18:	144029f3          	csrr	s3,sip
    asm volatile("csrr %0, satp" : "=r"(x));
    80200c1c:	18002b73          	csrr	s6,satp
    uint64 sie     = r_sie();
    uint64 sepc    = r_sepc();
    uint64 stval   = r_stval();
    uint64 sip     = r_sip();
    uint64 satp    = r_satp();
    printf("sstatus : %p\n", sstatus);
    80200c20:	00004517          	auipc	a0,0x4
    80200c24:	72850513          	addi	a0,a0,1832 # 80205348 <e_text+0x348>
    80200c28:	00048593          	mv	a1,s1
    80200c2c:	00002097          	auipc	ra,0x2
    80200c30:	f58080e7          	jalr	-168(ra) # 80202b84 <printf>
    if (explain)
    80200c34:	140a0463          	beqz	s4,80200d7c <print_sysregs+0x1ac>
        printf("- SUM:%d, SPP:%c, SPIE:%d, SIE: %d\n",
    80200c38:	0124d593          	srli	a1,s1,0x12
               (sstatus & SSTATUS_SUM) != 0,
               ((sstatus & SSTATUS_SPP) ? 'S' : 'U'),
    80200c3c:	1004f793          	andi	a5,s1,256
        printf("- SUM:%d, SPP:%c, SPIE:%d, SIE: %d\n",
    80200c40:	0015f593          	andi	a1,a1,1
    80200c44:	05500613          	li	a2,85
    80200c48:	18079e63          	bnez	a5,80200de4 <print_sysregs+0x214>
    80200c4c:	0014d713          	srli	a4,s1,0x1
    80200c50:	0054d693          	srli	a3,s1,0x5
    80200c54:	00177713          	andi	a4,a4,1
    80200c58:	0016f693          	andi	a3,a3,1
    80200c5c:	00004517          	auipc	a0,0x4
    80200c60:	74c50513          	addi	a0,a0,1868 # 802053a8 <e_text+0x3a8>
    80200c64:	00002097          	auipc	ra,0x2
    80200c68:	f20080e7          	jalr	-224(ra) # 80202b84 <printf>
               (sstatus & SSTATUS_SPIE) != 0,
               (sstatus & SSTATUS_SIE) != 0);
    printf("scause  : %p\n", scause);
    80200c6c:	000a8593          	mv	a1,s5
    80200c70:	00004517          	auipc	a0,0x4
    80200c74:	6e850513          	addi	a0,a0,1768 # 80205358 <e_text+0x358>
    80200c78:	00002097          	auipc	ra,0x2
    80200c7c:	f0c080e7          	jalr	-244(ra) # 80202b84 <printf>
    if (explain)
        printf("- Interrupt:%d, Code:%d\n", (scause & SCAUSE_INTERRUPT) != 0, (scause & SCAUSE_EXCEPTION_CODE_MASK));
    80200c80:	001a9613          	slli	a2,s5,0x1
    80200c84:	00165613          	srli	a2,a2,0x1
    80200c88:	03fad593          	srli	a1,s5,0x3f
    80200c8c:	00004517          	auipc	a0,0x4
    80200c90:	74450513          	addi	a0,a0,1860 # 802053d0 <e_text+0x3d0>
    80200c94:	00002097          	auipc	ra,0x2
    80200c98:	ef0080e7          	jalr	-272(ra) # 80202b84 <printf>

    printf("sepc    : %p\n", sepc);
    80200c9c:	000c0593          	mv	a1,s8
    80200ca0:	00004517          	auipc	a0,0x4
    80200ca4:	6c850513          	addi	a0,a0,1736 # 80205368 <e_text+0x368>
    80200ca8:	00002097          	auipc	ra,0x2
    80200cac:	edc080e7          	jalr	-292(ra) # 80202b84 <printf>
    printf("stval   : %p\n", stval);
    80200cb0:	000b8593          	mv	a1,s7
    80200cb4:	00004517          	auipc	a0,0x4
    80200cb8:	6c450513          	addi	a0,a0,1732 # 80205378 <e_text+0x378>
    80200cbc:	00002097          	auipc	ra,0x2
    80200cc0:	ec8080e7          	jalr	-312(ra) # 80202b84 <printf>
    printf("sip     : %p\n", sip);
    80200cc4:	00098593          	mv	a1,s3
    80200cc8:	00004517          	auipc	a0,0x4
    80200ccc:	6c050513          	addi	a0,a0,1728 # 80205388 <e_text+0x388>
    80200cd0:	00002097          	auipc	ra,0x2
    80200cd4:	eb4080e7          	jalr	-332(ra) # 80202b84 <printf>
    if (explain)
        printf("- Pending: Software:%d, Timer:%d, External:%d\n", (sip & SIE_SSIE) != 0, (sip & SIE_STIE) != 0, (sip & SIE_SEIE) != 0);
    80200cd8:	0099d693          	srli	a3,s3,0x9
    80200cdc:	0059d613          	srli	a2,s3,0x5
    80200ce0:	0019d593          	srli	a1,s3,0x1
    80200ce4:	0016f693          	andi	a3,a3,1
    80200ce8:	00167613          	andi	a2,a2,1
    80200cec:	0015f593          	andi	a1,a1,1
    80200cf0:	00004517          	auipc	a0,0x4
    80200cf4:	70050513          	addi	a0,a0,1792 # 802053f0 <e_text+0x3f0>
    80200cf8:	00002097          	auipc	ra,0x2
    80200cfc:	e8c080e7          	jalr	-372(ra) # 80202b84 <printf>

    printf("sie     : %p\n", sie);
    80200d00:	00090593          	mv	a1,s2
    80200d04:	00004517          	auipc	a0,0x4
    80200d08:	69450513          	addi	a0,a0,1684 # 80205398 <e_text+0x398>
    80200d0c:	00002097          	auipc	ra,0x2
    80200d10:	e78080e7          	jalr	-392(ra) # 80202b84 <printf>
    if (explain)
        printf("- Enabled: Software:%d, Timer:%d, External:%d\n", (sie & SIE_SSIE) != 0, (sie & SIE_STIE) != 0, (sie & SIE_SEIE) != 0);
    80200d14:	00995693          	srli	a3,s2,0x9
    80200d18:	00595613          	srli	a2,s2,0x5
    80200d1c:	00195593          	srli	a1,s2,0x1
    80200d20:	0016f693          	andi	a3,a3,1
    80200d24:	00167613          	andi	a2,a2,1
    80200d28:	0015f593          	andi	a1,a1,1
    80200d2c:	00004517          	auipc	a0,0x4
    80200d30:	6f450513          	addi	a0,a0,1780 # 80205420 <e_text+0x420>
    80200d34:	00002097          	auipc	ra,0x2
    80200d38:	e50080e7          	jalr	-432(ra) # 80202b84 <printf>

    printf("satp    : %p\n", satp);
}
    80200d3c:	04013403          	ld	s0,64(sp)
    80200d40:	04813083          	ld	ra,72(sp)
    80200d44:	03813483          	ld	s1,56(sp)
    80200d48:	03013903          	ld	s2,48(sp)
    80200d4c:	02813983          	ld	s3,40(sp)
    80200d50:	02013a03          	ld	s4,32(sp)
    80200d54:	01813a83          	ld	s5,24(sp)
    80200d58:	00813b83          	ld	s7,8(sp)
    80200d5c:	00013c03          	ld	s8,0(sp)
    printf("satp    : %p\n", satp);
    80200d60:	000b0593          	mv	a1,s6
}
    80200d64:	01013b03          	ld	s6,16(sp)
    printf("satp    : %p\n", satp);
    80200d68:	00004517          	auipc	a0,0x4
    80200d6c:	6e850513          	addi	a0,a0,1768 # 80205450 <e_text+0x450>
}
    80200d70:	05010113          	addi	sp,sp,80
    printf("satp    : %p\n", satp);
    80200d74:	00002317          	auipc	t1,0x2
    80200d78:	e1030067          	jr	-496(t1) # 80202b84 <printf>
    printf("scause  : %p\n", scause);
    80200d7c:	000a8593          	mv	a1,s5
    80200d80:	00004517          	auipc	a0,0x4
    80200d84:	5d850513          	addi	a0,a0,1496 # 80205358 <e_text+0x358>
    80200d88:	00002097          	auipc	ra,0x2
    80200d8c:	dfc080e7          	jalr	-516(ra) # 80202b84 <printf>
    printf("sepc    : %p\n", sepc);
    80200d90:	000c0593          	mv	a1,s8
    80200d94:	00004517          	auipc	a0,0x4
    80200d98:	5d450513          	addi	a0,a0,1492 # 80205368 <e_text+0x368>
    80200d9c:	00002097          	auipc	ra,0x2
    80200da0:	de8080e7          	jalr	-536(ra) # 80202b84 <printf>
    printf("stval   : %p\n", stval);
    80200da4:	000b8593          	mv	a1,s7
    80200da8:	00004517          	auipc	a0,0x4
    80200dac:	5d050513          	addi	a0,a0,1488 # 80205378 <e_text+0x378>
    80200db0:	00002097          	auipc	ra,0x2
    80200db4:	dd4080e7          	jalr	-556(ra) # 80202b84 <printf>
    printf("sip     : %p\n", sip);
    80200db8:	00098593          	mv	a1,s3
    80200dbc:	00004517          	auipc	a0,0x4
    80200dc0:	5cc50513          	addi	a0,a0,1484 # 80205388 <e_text+0x388>
    80200dc4:	00002097          	auipc	ra,0x2
    80200dc8:	dc0080e7          	jalr	-576(ra) # 80202b84 <printf>
    printf("sie     : %p\n", sie);
    80200dcc:	00090593          	mv	a1,s2
    80200dd0:	00004517          	auipc	a0,0x4
    80200dd4:	5c850513          	addi	a0,a0,1480 # 80205398 <e_text+0x398>
    80200dd8:	00002097          	auipc	ra,0x2
    80200ddc:	dac080e7          	jalr	-596(ra) # 80202b84 <printf>
    if (explain)
    80200de0:	f5dff06f          	j	80200d3c <print_sysregs+0x16c>
        printf("- SUM:%d, SPP:%c, SPIE:%d, SIE: %d\n",
    80200de4:	05300613          	li	a2,83
    80200de8:	e65ff06f          	j	80200c4c <print_sysregs+0x7c>

0000000080200dec <curr_proc>:
        freepages_count--;
    }
    release(&kpagelock);
    if (l)
        memset((char *)l, 0xaf, PGSIZE);
    return (void *)((uint64)l);
    80200dec:	fe010113          	addi	sp,sp,-32
    80200df0:	00113c23          	sd	ra,24(sp)
    80200df4:	00813823          	sd	s0,16(sp)
    80200df8:	00913423          	sd	s1,8(sp)
    80200dfc:	02010413          	addi	s0,sp,32
}
    80200e00:	00001097          	auipc	ra,0x1
    80200e04:	b64080e7          	jalr	-1180(ra) # 80201964 <push_off>

    80200e08:	00003097          	auipc	ra,0x3
    80200e0c:	2e4080e7          	jalr	740(ra) # 802040ec <mycpu>
// Object Allocator
    80200e10:	00853483          	ld	s1,8(a0)
// static uint64 allocator_mapped_va = KERNEL_ALLOCATOR_BASE;
    80200e14:	00001097          	auipc	ra,0x1
    80200e18:	bc4080e7          	jalr	-1084(ra) # 802019d8 <pop_off>

void allocator_init(struct allocator *alloc, char *name, uint64 object_size, uint64 count) {
    80200e1c:	01813083          	ld	ra,24(sp)
    80200e20:	01013403          	ld	s0,16(sp)
    80200e24:	00048513          	mv	a0,s1
    80200e28:	00813483          	ld	s1,8(sp)
    80200e2c:	02010113          	addi	sp,sp,32
    80200e30:	00008067          	ret

0000000080200e34 <kfreepage>:
void kfreepage(void *__pa pa) {
    80200e34:	fd010113          	addi	sp,sp,-48
    80200e38:	02813023          	sd	s0,32(sp)
    80200e3c:	00913c23          	sd	s1,24(sp)
    80200e40:	02113423          	sd	ra,40(sp)
    80200e44:	03010413          	addi	s0,sp,48
    if (!PGALIGNED((uint64)pa) || !(kpage_allocator_base <= kvaddr && kvaddr < kpage_allocator_base + kpage_allocator_size))
    80200e48:	03451793          	slli	a5,a0,0x34
void kfreepage(void *__pa pa) {
    80200e4c:	00050493          	mv	s1,a0
    if (!PGALIGNED((uint64)pa) || !(kpage_allocator_base <= kvaddr && kvaddr < kpage_allocator_base + kpage_allocator_size))
    80200e50:	0a079463          	bnez	a5,80200ef8 <kfreepage+0xc4>
    80200e54:	0001d797          	auipc	a5,0x1d
    80200e58:	5247b783          	ld	a5,1316(a5) # 8021e378 <kpage_allocator_base>
    80200e5c:	08f56e63          	bltu	a0,a5,80200ef8 <kfreepage+0xc4>
    80200e60:	0001d717          	auipc	a4,0x1d
    80200e64:	51073703          	ld	a4,1296(a4) # 8021e370 <kpage_allocator_size>
    80200e68:	00e787b3          	add	a5,a5,a4
    80200e6c:	08f57663          	bgeu	a0,a5,80200ef8 <kfreepage+0xc4>
    memset((void *)kvaddr, 0xdd, PGSIZE);
    80200e70:	00001637          	lui	a2,0x1
    80200e74:	0dd00593          	li	a1,221
    80200e78:	00003097          	auipc	ra,0x3
    80200e7c:	428080e7          	jalr	1064(ra) # 802042a0 <memset>
    if (kalloc_inited)
    80200e80:	0001d797          	auipc	a5,0x1d
    80200e84:	4d87a783          	lw	a5,1240(a5) # 8021e358 <kalloc_inited>
    80200e88:	04079e63          	bnez	a5,80200ee4 <kfreepage+0xb0>
    acquire(&kpagelock);
    80200e8c:	00008517          	auipc	a0,0x8
    80200e90:	24450513          	addi	a0,a0,580 # 802090d0 <kpagelock>
    80200e94:	00001097          	auipc	ra,0x1
    80200e98:	c68080e7          	jalr	-920(ra) # 80201afc <acquire>
    l->next       = kmem.freelist;
    80200e9c:	0001d697          	auipc	a3,0x1d
    80200ea0:	4c468693          	addi	a3,a3,1220 # 8021e360 <kmem>
    80200ea4:	0006b603          	ld	a2,0(a3)
    freepages_count++;
    80200ea8:	0001d717          	auipc	a4,0x1d
    80200eac:	4a870713          	addi	a4,a4,1192 # 8021e350 <freepages_count>
    80200eb0:	00073783          	ld	a5,0(a4)
}
    80200eb4:	02013403          	ld	s0,32(sp)
    l->next       = kmem.freelist;
    80200eb8:	00c4b023          	sd	a2,0(s1)
}
    80200ebc:	02813083          	ld	ra,40(sp)
    kmem.freelist = l;
    80200ec0:	0096b023          	sd	s1,0(a3)
    freepages_count++;
    80200ec4:	00178793          	addi	a5,a5,1
}
    80200ec8:	01813483          	ld	s1,24(sp)
    freepages_count++;
    80200ecc:	00f73023          	sd	a5,0(a4)
    release(&kpagelock);
    80200ed0:	00008517          	auipc	a0,0x8
    80200ed4:	20050513          	addi	a0,a0,512 # 802090d0 <kpagelock>
}
    80200ed8:	03010113          	addi	sp,sp,48
    release(&kpagelock);
    80200edc:	00001317          	auipc	t1,0x1
    80200ee0:	d6430067          	jr	-668(t1) # 80201c40 <release>
        debugf("free: %p", pa);
    80200ee4:	00048593          	mv	a1,s1
    80200ee8:	00000513          	li	a0,0
    80200eec:	00003097          	auipc	ra,0x3
    80200ef0:	660080e7          	jalr	1632(ra) # 8020454c <dummy>
    80200ef4:	f99ff06f          	j	80200e8c <kfreepage+0x58>
    asm volatile("mv %0, tp" : "=r"(x));
    80200ef8:	01213823          	sd	s2,16(sp)
    80200efc:	01313423          	sd	s3,8(sp)
    80200f00:	00020693          	mv	a3,tp
    return r_tp();
    80200f04:	0006899b          	sext.w	s3,a3
    push_off();
    80200f08:	00001097          	auipc	ra,0x1
    80200f0c:	a5c080e7          	jalr	-1444(ra) # 80201964 <push_off>
    struct cpu* c = mycpu();
    80200f10:	00003097          	auipc	ra,0x3
    80200f14:	1dc080e7          	jalr	476(ra) # 802040ec <mycpu>
    struct proc* p = c->proc;
    80200f18:	00853903          	ld	s2,8(a0)
    pop_off();
    80200f1c:	00001097          	auipc	ra,0x1
    80200f20:	abc080e7          	jalr	-1348(ra) # 802019d8 <pop_off>
    80200f24:	02090c63          	beqz	s2,80200f5c <kfreepage+0x128>
    80200f28:	02492703          	lw	a4,36(s2)
        panic("invalid page %p", pa);
    80200f2c:	00048893          	mv	a7,s1
    80200f30:	02e00813          	li	a6,46
    80200f34:	00004797          	auipc	a5,0x4
    80200f38:	52c78793          	addi	a5,a5,1324 # 80205460 <e_text+0x460>
    80200f3c:	00098693          	mv	a3,s3
    80200f40:	00004617          	auipc	a2,0x4
    80200f44:	0e860613          	addi	a2,a2,232 # 80205028 <e_text+0x28>
    80200f48:	01f00593          	li	a1,31
    80200f4c:	00004517          	auipc	a0,0x4
    80200f50:	52450513          	addi	a0,a0,1316 # 80205470 <e_text+0x470>
    80200f54:	00002097          	auipc	ra,0x2
    80200f58:	930080e7          	jalr	-1744(ra) # 80202884 <__panic>
    80200f5c:	fff00713          	li	a4,-1
    80200f60:	fcdff06f          	j	80200f2c <kfreepage+0xf8>

0000000080200f64 <kpgmgrinit>:
void kpgmgrinit() {
    80200f64:	fd010113          	addi	sp,sp,-48
    80200f68:	02813023          	sd	s0,32(sp)
    80200f6c:	00913c23          	sd	s1,24(sp)
    80200f70:	01313423          	sd	s3,8(sp)
    80200f74:	02113423          	sd	ra,40(sp)
    80200f78:	01213823          	sd	s2,16(sp)
    80200f7c:	01413023          	sd	s4,0(sp)
    80200f80:	03010413          	addi	s0,sp,48
    spinlock_init(&kpagelock, "pageallocator");
    80200f84:	00004597          	auipc	a1,0x4
    80200f88:	51c58593          	addi	a1,a1,1308 # 802054a0 <e_text+0x4a0>
    80200f8c:	00008517          	auipc	a0,0x8
    80200f90:	14450513          	addi	a0,a0,324 # 802090d0 <kpagelock>
    uint64 kpage_allocator_end = kpage_allocator_base + kpage_allocator_size;
    80200f94:	0001d997          	auipc	s3,0x1d
    80200f98:	3e498993          	addi	s3,s3,996 # 8021e378 <kpage_allocator_base>
    spinlock_init(&kpagelock, "pageallocator");
    80200f9c:	00001097          	auipc	ra,0x1
    80200fa0:	928080e7          	jalr	-1752(ra) # 802018c4 <spinlock_init>
    uint64 kpage_allocator_end = kpage_allocator_base + kpage_allocator_size;
    80200fa4:	0009b483          	ld	s1,0(s3)
    80200fa8:	0001d797          	auipc	a5,0x1d
    80200fac:	3c87b783          	ld	a5,968(a5) # 8021e370 <kpage_allocator_size>
    80200fb0:	00f484b3          	add	s1,s1,a5
    80200fb4:	00020913          	mv	s2,tp
    push_off();
    80200fb8:	00001097          	auipc	ra,0x1
    80200fbc:	9ac080e7          	jalr	-1620(ra) # 80201964 <push_off>
    struct cpu* c = mycpu();
    80200fc0:	00003097          	auipc	ra,0x3
    80200fc4:	12c080e7          	jalr	300(ra) # 802040ec <mycpu>
    struct proc* p = c->proc;
    80200fc8:	00853a03          	ld	s4,8(a0)
    return r_tp();
    80200fcc:	0009091b          	sext.w	s2,s2
    pop_off();
    80200fd0:	00001097          	auipc	ra,0x1
    80200fd4:	a08080e7          	jalr	-1528(ra) # 802019d8 <pop_off>
    80200fd8:	0a0a0c63          	beqz	s4,80201090 <kpgmgrinit+0x12c>
    80200fdc:	024a2703          	lw	a4,36(s4)
    infof("page allocator init: base: %p, stop: %p", kpage_allocator_base, kpage_allocator_end);
    80200fe0:	0009b803          	ld	a6,0(s3)
    80200fe4:	00005797          	auipc	a5,0x5
    80200fe8:	22c78793          	addi	a5,a5,556 # 80206210 <__func__.1>
    80200fec:	00090693          	mv	a3,s2
    80200ff0:	00004617          	auipc	a2,0x4
    80200ff4:	4c060613          	addi	a2,a2,1216 # 802054b0 <e_text+0x4b0>
    80200ff8:	00048893          	mv	a7,s1
    80200ffc:	02200593          	li	a1,34
    80201000:	00004517          	auipc	a0,0x4
    80201004:	4b850513          	addi	a0,a0,1208 # 802054b8 <e_text+0x4b8>
    80201008:	00002097          	auipc	ra,0x2
    8020100c:	b7c080e7          	jalr	-1156(ra) # 80202b84 <printf>
    assert(PGALIGNED(kpage_allocator_base));
    80201010:	0009b703          	ld	a4,0(s3)
    80201014:	000016b7          	lui	a3,0x1
    80201018:	fff68793          	addi	a5,a3,-1 # fff <_entry-0x801ff001>
    8020101c:	00f77633          	and	a2,a4,a5
    80201020:	0c061263          	bnez	a2,802010e4 <kpgmgrinit+0x180>
    assert(PGALIGNED(kpage_allocator_end));
    80201024:	00f4f7b3          	and	a5,s1,a5
    80201028:	06079863          	bnez	a5,80201098 <kpgmgrinit+0x134>
    for (uint64 p = kpage_allocator_end - PGSIZE; p >= kpage_allocator_base; p -= PGSIZE) {
    8020102c:	40d484b3          	sub	s1,s1,a3
    80201030:	02e4ea63          	bltu	s1,a4,80201064 <kpgmgrinit+0x100>
    80201034:	0001d917          	auipc	s2,0x1d
    80201038:	31c90913          	addi	s2,s2,796 # 8021e350 <freepages_count>
    8020103c:	fffffa37          	lui	s4,0xfffff
        freepages_count++;
    80201040:	00093783          	ld	a5,0(s2)
        kfreepage((void *)(p));
    80201044:	00048513          	mv	a0,s1
    for (uint64 p = kpage_allocator_end - PGSIZE; p >= kpage_allocator_base; p -= PGSIZE) {
    80201048:	014484b3          	add	s1,s1,s4
        freepages_count++;
    8020104c:	00178793          	addi	a5,a5,1
    80201050:	00f93023          	sd	a5,0(s2)
        kfreepage((void *)(p));
    80201054:	00000097          	auipc	ra,0x0
    80201058:	de0080e7          	jalr	-544(ra) # 80200e34 <kfreepage>
    for (uint64 p = kpage_allocator_end - PGSIZE; p >= kpage_allocator_base; p -= PGSIZE) {
    8020105c:	0009b783          	ld	a5,0(s3)
    80201060:	fef4f0e3          	bgeu	s1,a5,80201040 <kpgmgrinit+0xdc>
}
    80201064:	02813083          	ld	ra,40(sp)
    80201068:	02013403          	ld	s0,32(sp)
    kalloc_inited = 1;
    8020106c:	00100793          	li	a5,1
    80201070:	0001d717          	auipc	a4,0x1d
    80201074:	2ef72423          	sw	a5,744(a4) # 8021e358 <kalloc_inited>
}
    80201078:	01813483          	ld	s1,24(sp)
    8020107c:	01013903          	ld	s2,16(sp)
    80201080:	00813983          	ld	s3,8(sp)
    80201084:	00013a03          	ld	s4,0(sp)
    80201088:	03010113          	addi	sp,sp,48
    8020108c:	00008067          	ret
    80201090:	fff00713          	li	a4,-1
    80201094:	f4dff06f          	j	80200fe0 <kpgmgrinit+0x7c>
    80201098:	00020493          	mv	s1,tp
    return r_tp();
    8020109c:	0004849b          	sext.w	s1,s1
    struct proc *p = curr_proc();
    802010a0:	00000097          	auipc	ra,0x0
    802010a4:	d4c080e7          	jalr	-692(ra) # 80200dec <curr_proc>
    return p ? p->pid : -1;
    802010a8:	06050263          	beqz	a0,8020110c <kpgmgrinit+0x1a8>
    802010ac:	02452703          	lw	a4,36(a0)
    assert(PGALIGNED(kpage_allocator_end));
    802010b0:	00004897          	auipc	a7,0x4
    802010b4:	47088893          	addi	a7,a7,1136 # 80205520 <e_text+0x520>
    802010b8:	01c00813          	li	a6,28
    802010bc:	00004797          	auipc	a5,0x4
    802010c0:	3a478793          	addi	a5,a5,932 # 80205460 <e_text+0x460>
    802010c4:	00048693          	mv	a3,s1
    802010c8:	00004617          	auipc	a2,0x4
    802010cc:	f6060613          	addi	a2,a2,-160 # 80205028 <e_text+0x28>
    802010d0:	01f00593          	li	a1,31
    802010d4:	00004517          	auipc	a0,0x4
    802010d8:	f5c50513          	addi	a0,a0,-164 # 80205030 <e_text+0x30>
    802010dc:	00001097          	auipc	ra,0x1
    802010e0:	7a8080e7          	jalr	1960(ra) # 80202884 <__panic>
    802010e4:	00020493          	mv	s1,tp
    802010e8:	0004849b          	sext.w	s1,s1
    struct proc *p = curr_proc();
    802010ec:	00000097          	auipc	ra,0x0
    802010f0:	d00080e7          	jalr	-768(ra) # 80200dec <curr_proc>
    return p ? p->pid : -1;
    802010f4:	02050063          	beqz	a0,80201114 <kpgmgrinit+0x1b0>
    802010f8:	02452703          	lw	a4,36(a0)
    assert(PGALIGNED(kpage_allocator_base));
    802010fc:	00004897          	auipc	a7,0x4
    80201100:	40488893          	addi	a7,a7,1028 # 80205500 <e_text+0x500>
    80201104:	01b00813          	li	a6,27
    80201108:	fb5ff06f          	j	802010bc <kpgmgrinit+0x158>
    8020110c:	fff00713          	li	a4,-1
    80201110:	fa1ff06f          	j	802010b0 <kpgmgrinit+0x14c>
    80201114:	fff00713          	li	a4,-1
    80201118:	fe5ff06f          	j	802010fc <kpgmgrinit+0x198>

000000008020111c <kallocpage>:
void *__pa kallocpage() {
    8020111c:	fe010113          	addi	sp,sp,-32
    80201120:	00813823          	sd	s0,16(sp)
    80201124:	00113c23          	sd	ra,24(sp)
    80201128:	00913423          	sd	s1,8(sp)
    8020112c:	02010413          	addi	s0,sp,32
    asm volatile("mv tp, %0" : : "r"(x));
}

static inline uint64 r_ra() {
    uint64 x;
    asm volatile("mv %0, ra" : "=r"(x));
    80201130:	00008793          	mv	a5,ra
    acquire(&kpagelock);
    80201134:	00008517          	auipc	a0,0x8
    80201138:	f9c50513          	addi	a0,a0,-100 # 802090d0 <kpagelock>
    8020113c:	00001097          	auipc	ra,0x1
    80201140:	9c0080e7          	jalr	-1600(ra) # 80201afc <acquire>
    l = kmem.freelist;
    80201144:	0001d717          	auipc	a4,0x1d
    80201148:	21c70713          	addi	a4,a4,540 # 8021e360 <kmem>
    8020114c:	00073483          	ld	s1,0(a4)
    if (l) {
    80201150:	04048e63          	beqz	s1,802011ac <kallocpage+0x90>
        freepages_count--;
    80201154:	0001d697          	auipc	a3,0x1d
    80201158:	1fc68693          	addi	a3,a3,508 # 8021e350 <freepages_count>
    8020115c:	0006b783          	ld	a5,0(a3)
        kmem.freelist = l->next;
    80201160:	0004b603          	ld	a2,0(s1)
    release(&kpagelock);
    80201164:	00008517          	auipc	a0,0x8
    80201168:	f6c50513          	addi	a0,a0,-148 # 802090d0 <kpagelock>
        freepages_count--;
    8020116c:	fff78793          	addi	a5,a5,-1
        kmem.freelist = l->next;
    80201170:	00c73023          	sd	a2,0(a4)
        freepages_count--;
    80201174:	00f6b023          	sd	a5,0(a3)
    release(&kpagelock);
    80201178:	00001097          	auipc	ra,0x1
    8020117c:	ac8080e7          	jalr	-1336(ra) # 80201c40 <release>
        memset((char *)l, 0xaf, PGSIZE);
    80201180:	00048513          	mv	a0,s1
    80201184:	00001637          	lui	a2,0x1
    80201188:	0af00593          	li	a1,175
    8020118c:	00003097          	auipc	ra,0x3
    80201190:	114080e7          	jalr	276(ra) # 802042a0 <memset>
}
    80201194:	01813083          	ld	ra,24(sp)
    80201198:	01013403          	ld	s0,16(sp)
    8020119c:	00048513          	mv	a0,s1
    802011a0:	00813483          	ld	s1,8(sp)
    802011a4:	02010113          	addi	sp,sp,32
    802011a8:	00008067          	ret
    release(&kpagelock);
    802011ac:	00008517          	auipc	a0,0x8
    802011b0:	f2450513          	addi	a0,a0,-220 # 802090d0 <kpagelock>
    802011b4:	00001097          	auipc	ra,0x1
    802011b8:	a8c080e7          	jalr	-1396(ra) # 80201c40 <release>
}
    802011bc:	01813083          	ld	ra,24(sp)
    802011c0:	01013403          	ld	s0,16(sp)
    802011c4:	00048513          	mv	a0,s1
    802011c8:	00813483          	ld	s1,8(sp)
    802011cc:	02010113          	addi	sp,sp,32
    802011d0:	00008067          	ret

00000000802011d4 <allocator_init>:
void allocator_init(struct allocator *alloc, char *name, uint64 object_size, uint64 count) {
    802011d4:	f8010113          	addi	sp,sp,-128
    802011d8:	06813823          	sd	s0,112(sp)
    802011dc:	06113c23          	sd	ra,120(sp)
    802011e0:	08010413          	addi	s0,sp,128
    // Under NOMMU mode, we require the sizeof([header, object]) must be smaller than a page.
    //  because we cannot guarantee the [haeder,object] is in the same page.
    assert(object_size < PGSIZE - sizeof(struct linklist));
    802011e4:	000017b7          	lui	a5,0x1
    802011e8:	ff778793          	addi	a5,a5,-9 # ff7 <_entry-0x801ff009>
    802011ec:	06913423          	sd	s1,104(sp)
    802011f0:	07213023          	sd	s2,96(sp)
    802011f4:	05313c23          	sd	s3,88(sp)
    802011f8:	32c7e663          	bltu	a5,a2,80201524 <allocator_init+0x350>

    // The allocator leaves spaces for a `struct linklist` before every object:
    //  [PGALIGNED][linklist, object][linklist, object]...[linklist, object]..[PGALIGNED]
    //             ^__pool_base, first object             ^_ the last obj               ^__pool_end

    memset(alloc, 0, sizeof(*alloc));
    802011fc:	00060493          	mv	s1,a2
    80201200:	00058913          	mv	s2,a1
    80201204:	05800613          	li	a2,88
    80201208:	00000593          	li	a1,0
    8020120c:	00068993          	mv	s3,a3
    80201210:	03913423          	sd	s9,40(sp)
    80201214:	03a13023          	sd	s10,32(sp)
    80201218:	00050d13          	mv	s10,a0
    8020121c:	00003097          	auipc	ra,0x3
    80201220:	084080e7          	jalr	132(ra) # 802042a0 <memset>
    // record basic properties of the allocator
    alloc->name = name;
    spinlock_init(&alloc->lock, "allocator");
    80201224:	00004597          	auipc	a1,0x4
    80201228:	34c58593          	addi	a1,a1,844 # 80205570 <e_text+0x570>
    8020122c:	008d0513          	addi	a0,s10,8
    alloc->name = name;
    80201230:	012d3023          	sd	s2,0(s10)
    spinlock_init(&alloc->lock, "allocator");
    80201234:	00000097          	auipc	ra,0x0
    80201238:	690080e7          	jalr	1680(ra) # 802018c4 <spinlock_init>
    alloc->object_size         = object_size;
    alloc->object_size_aligned = ROUNDUP_2N(object_size + sizeof(struct linklist), 8);
    8020123c:	00f48793          	addi	a5,s1,15
    80201240:	ff87f793          	andi	a5,a5,-8
    alloc->object_size         = object_size;
    80201244:	029d3823          	sd	s1,48(s10)
    alloc->object_size_aligned = ROUNDUP_2N(object_size + sizeof(struct linklist), 8);
    80201248:	02fd3c23          	sd	a5,56(s10)
    alloc->max_count           = count;
    8020124c:	053d3823          	sd	s3,80(s10)

    uint64 addr = (uint64)kallocpage();
    80201250:	00000097          	auipc	ra,0x0
    80201254:	ecc080e7          	jalr	-308(ra) # 8020111c <kallocpage>
    80201258:	05413823          	sd	s4,80(sp)
    8020125c:	05513423          	sd	s5,72(sp)
    80201260:	00050c93          	mv	s9,a0
    assert(addr);
    80201264:	30050463          	beqz	a0,8020156c <allocator_init+0x398>
    memset((void *)addr, 0, PGSIZE);
    80201268:	00001637          	lui	a2,0x1
    8020126c:	00000593          	li	a1,0
    80201270:	00003097          	auipc	ra,0x3
    80201274:	030080e7          	jalr	48(ra) # 802042a0 <memset>
    asm volatile("mv %0, tp" : "=r"(x));
    80201278:	00020493          	mv	s1,tp
    push_off();
    8020127c:	00000097          	auipc	ra,0x0
    80201280:	6e8080e7          	jalr	1768(ra) # 80201964 <push_off>
    struct cpu* c = mycpu();
    80201284:	00003097          	auipc	ra,0x3
    80201288:	e68080e7          	jalr	-408(ra) # 802040ec <mycpu>
    struct proc* p = c->proc;
    8020128c:	00853a03          	ld	s4,8(a0)
    return r_tp();
    80201290:	0004849b          	sext.w	s1,s1
    pop_off();
    80201294:	00000097          	auipc	ra,0x0
    80201298:	744080e7          	jalr	1860(ra) # 802019d8 <pop_off>
    8020129c:	220a0063          	beqz	s4,802014bc <allocator_init+0x2e8>
    802012a0:	024a2703          	lw	a4,36(s4) # fffffffffffff024 <e_bss+0xffffffff7fde0024>

    uint64 seg_start = addr, idx_start = 0;
    infof("allocator %s inited [NOMMU]. start: %p", name, seg_start);
    802012a4:	000c8893          	mv	a7,s9
    802012a8:	00090813          	mv	a6,s2
    802012ac:	00005797          	auipc	a5,0x5
    802012b0:	f7478793          	addi	a5,a5,-140 # 80206220 <__func__.0>
    802012b4:	00048693          	mv	a3,s1
    802012b8:	00004617          	auipc	a2,0x4
    802012bc:	1f860613          	addi	a2,a2,504 # 802054b0 <e_text+0x4b0>
    802012c0:	02200593          	li	a1,34
    802012c4:	00004517          	auipc	a0,0x4
    802012c8:	2c450513          	addi	a0,a0,708 # 80205588 <e_text+0x588>
    802012cc:	00002097          	auipc	ra,0x2
    802012d0:	8b8080e7          	jalr	-1864(ra) # 80202b84 <printf>

    for (uint64 i = 0; i < count; i++) {
    802012d4:	1c098663          	beqz	s3,802014a0 <allocator_init+0x2cc>
    802012d8:	03713c23          	sd	s7,56(sp)
    802012dc:	03813823          	sd	s8,48(sp)
    802012e0:	01b13c23          	sd	s11,24(sp)
        if (((addr + alloc->object_size_aligned) >> PGSHIFT) != ((addr) >> PGSHIFT)) {
    802012e4:	038d3703          	ld	a4,56(s10)
    802012e8:	05613023          	sd	s6,64(sp)
    uint64 seg_start = addr, idx_start = 0;
    802012ec:	000c8a93          	mv	s5,s9
    for (uint64 i = 0; i < count; i++) {
    802012f0:	00000d93          	li	s11,0
    uint64 seg_start = addr, idx_start = 0;
    802012f4:	00000a13          	li	s4,0
            // if we get the adjacent page, use the space between them.
            //  we can allocate next object just at `addr`.

            if ((next_page >> PGSHIFT) != (addr >> PGSHIFT) + 1) {
                // otherwise, we meet the non-continuous page, report it and set addr = next_page.
                infof(" - segment: [%d -> %d]: [%p -> %p)", idx_start, i, seg_start, addr);
    802012f8:	00005c17          	auipc	s8,0x5
    802012fc:	f28c0c13          	addi	s8,s8,-216 # 80206220 <__func__.0>
    80201300:	00004b97          	auipc	s7,0x4
    80201304:	1b0b8b93          	addi	s7,s7,432 # 802054b0 <e_text+0x4b0>
    80201308:	0200006f          	j	80201328 <allocator_init+0x154>

            // Note: if we have mmu to do address translate, we just simply let the VA to be continuous.
            //        we don't care whether the mapped PA is continuous or not.
        }

        struct linklist *l = (struct linklist *)addr;
    8020130c:	000c8493          	mv	s1,s9
    80201310:	00078c93          	mv	s9,a5
        l->next            = alloc->freelist;
    80201314:	028d3783          	ld	a5,40(s10)
    for (uint64 i = 0; i < count; i++) {
    80201318:	001d8d93          	addi	s11,s11,1
        l->next            = alloc->freelist;
    8020131c:	00f4b023          	sd	a5,0(s1)
        alloc->freelist    = l;
    80201320:	029d3423          	sd	s1,40(s10)
    for (uint64 i = 0; i < count; i++) {
    80201324:	07b98063          	beq	s3,s11,80201384 <allocator_init+0x1b0>
        if (((addr + alloc->object_size_aligned) >> PGSHIFT) != ((addr) >> PGSHIFT)) {
    80201328:	019707b3          	add	a5,a4,s9
    8020132c:	00ccd913          	srli	s2,s9,0xc
    80201330:	00c7d693          	srli	a3,a5,0xc
    80201334:	fd268ce3          	beq	a3,s2,8020130c <allocator_init+0x138>
            uint64 next_page = (uint64)kallocpage();
    80201338:	00000097          	auipc	ra,0x0
    8020133c:	de4080e7          	jalr	-540(ra) # 8020111c <kallocpage>
    80201340:	00050493          	mv	s1,a0
            assert(next_page);
    80201344:	18050063          	beqz	a0,802014c4 <allocator_init+0x2f0>
            memset((void *)next_page, 0, PGSIZE);
    80201348:	00001637          	lui	a2,0x1
    8020134c:	00000593          	li	a1,0
    80201350:	00003097          	auipc	ra,0x3
    80201354:	f50080e7          	jalr	-176(ra) # 802042a0 <memset>
            if ((next_page >> PGSHIFT) != (addr >> PGSHIFT) + 1) {
    80201358:	00c4d793          	srli	a5,s1,0xc
    8020135c:	00190913          	addi	s2,s2,1
    80201360:	0d279863          	bne	a5,s2,80201430 <allocator_init+0x25c>
        l->next            = alloc->freelist;
    80201364:	028d3783          	ld	a5,40(s10)
        struct linklist *l = (struct linklist *)addr;
    80201368:	000c8493          	mv	s1,s9

        addr += alloc->object_size_aligned;
    8020136c:	038d3703          	ld	a4,56(s10)
        l->next            = alloc->freelist;
    80201370:	00f4b023          	sd	a5,0(s1)
    for (uint64 i = 0; i < count; i++) {
    80201374:	001d8d93          	addi	s11,s11,1
        alloc->freelist    = l;
    80201378:	029d3423          	sd	s1,40(s10)
        addr += alloc->object_size_aligned;
    8020137c:	00ec8cb3          	add	s9,s9,a4
    for (uint64 i = 0; i < count; i++) {
    80201380:	fbb994e3          	bne	s3,s11,80201328 <allocator_init+0x154>
    80201384:	04013b03          	ld	s6,64(sp)
    80201388:	03813b83          	ld	s7,56(sp)
    8020138c:	03013c03          	ld	s8,48(sp)
    80201390:	01813d83          	ld	s11,24(sp)
    80201394:	00020493          	mv	s1,tp
    push_off();
    80201398:	00000097          	auipc	ra,0x0
    8020139c:	5cc080e7          	jalr	1484(ra) # 80201964 <push_off>
    struct cpu* c = mycpu();
    802013a0:	00003097          	auipc	ra,0x3
    802013a4:	d4c080e7          	jalr	-692(ra) # 802040ec <mycpu>
    struct proc* p = c->proc;
    802013a8:	00853903          	ld	s2,8(a0)
    return r_tp();
    802013ac:	0004849b          	sext.w	s1,s1
    pop_off();
    802013b0:	00000097          	auipc	ra,0x0
    802013b4:	628080e7          	jalr	1576(ra) # 802019d8 <pop_off>
    802013b8:	0e090e63          	beqz	s2,802014b4 <allocator_init+0x2e0>
    802013bc:	02492703          	lw	a4,36(s2)
    }
    infof(" - segment: [%d -> %d]: [%p -> %p)", idx_start, count, seg_start, addr);
    802013c0:	01913423          	sd	s9,8(sp)
    802013c4:	01513023          	sd	s5,0(sp)
    802013c8:	00098893          	mv	a7,s3
    802013cc:	000a0813          	mv	a6,s4
    802013d0:	00005797          	auipc	a5,0x5
    802013d4:	e5078793          	addi	a5,a5,-432 # 80206220 <__func__.0>
    802013d8:	00048693          	mv	a3,s1
    802013dc:	00004617          	auipc	a2,0x4
    802013e0:	0d460613          	addi	a2,a2,212 # 802054b0 <e_text+0x4b0>
    802013e4:	02200593          	li	a1,34
    802013e8:	00004517          	auipc	a0,0x4
    802013ec:	1f050513          	addi	a0,a0,496 # 802055d8 <e_text+0x5d8>
    802013f0:	00001097          	auipc	ra,0x1
    802013f4:	794080e7          	jalr	1940(ra) # 80202b84 <printf>

    alloc->available_count = alloc->max_count;
    802013f8:	050d3783          	ld	a5,80(s10)
    alloc->allocated_count = 0;
}
    802013fc:	07813083          	ld	ra,120(sp)
    80201400:	07013403          	ld	s0,112(sp)
    alloc->allocated_count = 0;
    80201404:	040d3023          	sd	zero,64(s10)
    alloc->available_count = alloc->max_count;
    80201408:	04fd3423          	sd	a5,72(s10)
    8020140c:	06813483          	ld	s1,104(sp)
    80201410:	06013903          	ld	s2,96(sp)
    80201414:	05813983          	ld	s3,88(sp)
    80201418:	05013a03          	ld	s4,80(sp)
    8020141c:	04813a83          	ld	s5,72(sp)
    80201420:	02813c83          	ld	s9,40(sp)
    80201424:	02013d03          	ld	s10,32(sp)
}
    80201428:	08010113          	addi	sp,sp,128
    8020142c:	00008067          	ret
    80201430:	00020913          	mv	s2,tp
    push_off();
    80201434:	00000097          	auipc	ra,0x0
    80201438:	530080e7          	jalr	1328(ra) # 80201964 <push_off>
    struct cpu* c = mycpu();
    8020143c:	00003097          	auipc	ra,0x3
    80201440:	cb0080e7          	jalr	-848(ra) # 802040ec <mycpu>
    struct proc* p = c->proc;
    80201444:	00853b03          	ld	s6,8(a0)
    return r_tp();
    80201448:	0009091b          	sext.w	s2,s2
    pop_off();
    8020144c:	00000097          	auipc	ra,0x0
    80201450:	58c080e7          	jalr	1420(ra) # 802019d8 <pop_off>
    80201454:	040b0c63          	beqz	s6,802014ac <allocator_init+0x2d8>
    80201458:	024b2703          	lw	a4,36(s6)
                infof(" - segment: [%d -> %d]: [%p -> %p)", idx_start, i, seg_start, addr);
    8020145c:	01913423          	sd	s9,8(sp)
    80201460:	01513023          	sd	s5,0(sp)
    80201464:	000a0813          	mv	a6,s4
    80201468:	000d8893          	mv	a7,s11
    8020146c:	000c0793          	mv	a5,s8
    80201470:	00090693          	mv	a3,s2
    80201474:	000b8613          	mv	a2,s7
    80201478:	02200593          	li	a1,34
    8020147c:	00004517          	auipc	a0,0x4
    80201480:	15c50513          	addi	a0,a0,348 # 802055d8 <e_text+0x5d8>
    80201484:	00001097          	auipc	ra,0x1
    80201488:	700080e7          	jalr	1792(ra) # 80202b84 <printf>
        addr += alloc->object_size_aligned;
    8020148c:	038d3703          	ld	a4,56(s10)
                idx_start = i;
    80201490:	000d8a13          	mv	s4,s11
                seg_start = addr;
    80201494:	00048a93          	mv	s5,s1
        addr += alloc->object_size_aligned;
    80201498:	00e48cb3          	add	s9,s1,a4
    8020149c:	e79ff06f          	j	80201314 <allocator_init+0x140>
    uint64 seg_start = addr, idx_start = 0;
    802014a0:	00000a13          	li	s4,0
    802014a4:	000c8a93          	mv	s5,s9
    802014a8:	eedff06f          	j	80201394 <allocator_init+0x1c0>
    802014ac:	fff00713          	li	a4,-1
    802014b0:	fadff06f          	j	8020145c <allocator_init+0x288>
    802014b4:	fff00713          	li	a4,-1
    802014b8:	f09ff06f          	j	802013c0 <allocator_init+0x1ec>
    802014bc:	fff00713          	li	a4,-1
    802014c0:	de5ff06f          	j	802012a4 <allocator_init+0xd0>
    802014c4:	00020493          	mv	s1,tp
    push_off();
    802014c8:	00000097          	auipc	ra,0x0
    802014cc:	49c080e7          	jalr	1180(ra) # 80201964 <push_off>
    struct cpu* c = mycpu();
    802014d0:	00003097          	auipc	ra,0x3
    802014d4:	c1c080e7          	jalr	-996(ra) # 802040ec <mycpu>
    struct proc* p = c->proc;
    802014d8:	00853903          	ld	s2,8(a0)
    return r_tp();
    802014dc:	0004849b          	sext.w	s1,s1
    pop_off();
    802014e0:	00000097          	auipc	ra,0x0
    802014e4:	4f8080e7          	jalr	1272(ra) # 802019d8 <pop_off>
    802014e8:	0a090e63          	beqz	s2,802015a4 <allocator_init+0x3d0>
    802014ec:	02492703          	lw	a4,36(s2)
            assert(next_page);
    802014f0:	00004897          	auipc	a7,0x4
    802014f4:	0d888893          	addi	a7,a7,216 # 802055c8 <e_text+0x5c8>
    802014f8:	06e00813          	li	a6,110
    assert(addr);
    802014fc:	00004797          	auipc	a5,0x4
    80201500:	f6478793          	addi	a5,a5,-156 # 80205460 <e_text+0x460>
    80201504:	00048693          	mv	a3,s1
    80201508:	00004617          	auipc	a2,0x4
    8020150c:	b2060613          	addi	a2,a2,-1248 # 80205028 <e_text+0x28>
    80201510:	01f00593          	li	a1,31
    80201514:	00004517          	auipc	a0,0x4
    80201518:	b1c50513          	addi	a0,a0,-1252 # 80205030 <e_text+0x30>
    8020151c:	00001097          	auipc	ra,0x1
    80201520:	368080e7          	jalr	872(ra) # 80202884 <__panic>
    80201524:	05413823          	sd	s4,80(sp)
    80201528:	05513423          	sd	s5,72(sp)
    8020152c:	05613023          	sd	s6,64(sp)
    80201530:	03713c23          	sd	s7,56(sp)
    80201534:	03813823          	sd	s8,48(sp)
    80201538:	03913423          	sd	s9,40(sp)
    8020153c:	03a13023          	sd	s10,32(sp)
    80201540:	01b13c23          	sd	s11,24(sp)
    80201544:	00020493          	mv	s1,tp
    return r_tp();
    80201548:	0004849b          	sext.w	s1,s1
    struct proc *p = curr_proc();
    8020154c:	00000097          	auipc	ra,0x0
    80201550:	8a0080e7          	jalr	-1888(ra) # 80200dec <curr_proc>
    return p ? p->pid : -1;
    80201554:	04050c63          	beqz	a0,802015ac <allocator_init+0x3d8>
    80201558:	02452703          	lw	a4,36(a0)
    assert(object_size < PGSIZE - sizeof(struct linklist));
    8020155c:	00004897          	auipc	a7,0x4
    80201560:	fe488893          	addi	a7,a7,-28 # 80205540 <e_text+0x540>
    80201564:	05500813          	li	a6,85
    80201568:	f95ff06f          	j	802014fc <allocator_init+0x328>
    8020156c:	05613023          	sd	s6,64(sp)
    80201570:	03713c23          	sd	s7,56(sp)
    80201574:	03813823          	sd	s8,48(sp)
    80201578:	01b13c23          	sd	s11,24(sp)
    8020157c:	00020493          	mv	s1,tp
    80201580:	0004849b          	sext.w	s1,s1
    struct proc *p = curr_proc();
    80201584:	00000097          	auipc	ra,0x0
    80201588:	868080e7          	jalr	-1944(ra) # 80200dec <curr_proc>
    return p ? p->pid : -1;
    8020158c:	02050463          	beqz	a0,802015b4 <allocator_init+0x3e0>
    80201590:	02452703          	lw	a4,36(a0)
    assert(addr);
    80201594:	00004897          	auipc	a7,0x4
    80201598:	fec88893          	addi	a7,a7,-20 # 80205580 <e_text+0x580>
    8020159c:	06400813          	li	a6,100
    802015a0:	f5dff06f          	j	802014fc <allocator_init+0x328>
    802015a4:	fff00713          	li	a4,-1
    802015a8:	f49ff06f          	j	802014f0 <allocator_init+0x31c>
    802015ac:	fff00713          	li	a4,-1
    802015b0:	fadff06f          	j	8020155c <allocator_init+0x388>
    802015b4:	fff00713          	li	a4,-1
    802015b8:	fddff06f          	j	80201594 <allocator_init+0x3c0>

00000000802015bc <kalloc>:

void *kalloc(struct allocator *alloc) {
    802015bc:	fd010113          	addi	sp,sp,-48
    802015c0:	02813023          	sd	s0,32(sp)
    802015c4:	02113423          	sd	ra,40(sp)
    802015c8:	00913c23          	sd	s1,24(sp)
    802015cc:	01213823          	sd	s2,16(sp)
    802015d0:	01313423          	sd	s3,8(sp)
    802015d4:	03010413          	addi	s0,sp,48
    assert(alloc);
    802015d8:	0a050663          	beqz	a0,80201684 <kalloc+0xc8>
    acquire(&alloc->lock);
    802015dc:	00850993          	addi	s3,a0,8
    802015e0:	00050493          	mv	s1,a0
    802015e4:	00098513          	mv	a0,s3
    802015e8:	00000097          	auipc	ra,0x0
    802015ec:	514080e7          	jalr	1300(ra) # 80201afc <acquire>

    if (alloc->available_count == 0)
    802015f0:	0484b783          	ld	a5,72(s1)
    802015f4:	12078063          	beqz	a5,80201714 <kalloc+0x158>

    alloc->available_count--;

    void *ret;

    struct linklist *l = alloc->freelist;
    802015f8:	0284b503          	ld	a0,40(s1)
    alloc->available_count--;
    802015fc:	fff78793          	addi	a5,a5,-1
    80201600:	04f4b423          	sd	a5,72(s1)
    if (l) {
    80201604:	0c050663          	beqz	a0,802016d0 <kalloc+0x114>
        alloc->freelist = l->next;
        ret             = (void *)((uint64)l + sizeof(*l));

        alloc->allocated_count++;
    80201608:	0404b783          	ld	a5,64(s1)
        alloc->freelist = l->next;
    8020160c:	00053703          	ld	a4,0(a0)

        memset(l, 0xff, sizeof(*l));
    80201610:	00800613          	li	a2,8
        alloc->allocated_count++;
    80201614:	00178793          	addi	a5,a5,1
        alloc->freelist = l->next;
    80201618:	02e4b423          	sd	a4,40(s1)
        alloc->allocated_count++;
    8020161c:	04f4b023          	sd	a5,64(s1)
        memset(l, 0xff, sizeof(*l));
    80201620:	0ff00593          	li	a1,255
        ret             = (void *)((uint64)l + sizeof(*l));
    80201624:	00850913          	addi	s2,a0,8
        memset(l, 0xff, sizeof(*l));
    80201628:	00003097          	auipc	ra,0x3
    8020162c:	c78080e7          	jalr	-904(ra) # 802042a0 <memset>
        memset(ret, 0xfe, alloc->object_size);
    80201630:	0304a603          	lw	a2,48(s1)
    80201634:	0fe00593          	li	a1,254
    80201638:	00090513          	mv	a0,s2
    8020163c:	00003097          	auipc	ra,0x3
    80201640:	c64080e7          	jalr	-924(ra) # 802042a0 <memset>
    } else {
        panic("should be guarded by available_count");
    }
    release(&alloc->lock);
    80201644:	00098513          	mv	a0,s3
    80201648:	00000097          	auipc	ra,0x0
    8020164c:	5f8080e7          	jalr	1528(ra) # 80201c40 <release>

    tracef("kalloc(%s) returns %p", alloc->name, ret);
    80201650:	0004b583          	ld	a1,0(s1)
    80201654:	00090613          	mv	a2,s2
    80201658:	00000513          	li	a0,0
    8020165c:	00003097          	auipc	ra,0x3
    80201660:	ef0080e7          	jalr	-272(ra) # 8020454c <dummy>

    return ret;
}
    80201664:	02813083          	ld	ra,40(sp)
    80201668:	02013403          	ld	s0,32(sp)
    8020166c:	01813483          	ld	s1,24(sp)
    80201670:	00813983          	ld	s3,8(sp)
    80201674:	00090513          	mv	a0,s2
    80201678:	01013903          	ld	s2,16(sp)
    8020167c:	03010113          	addi	sp,sp,48
    80201680:	00008067          	ret
    80201684:	00020493          	mv	s1,tp
    80201688:	0004849b          	sext.w	s1,s1
    struct proc *p = curr_proc();
    8020168c:	fffff097          	auipc	ra,0xfffff
    80201690:	760080e7          	jalr	1888(ra) # 80200dec <curr_proc>
    return p ? p->pid : -1;
    80201694:	0c050263          	beqz	a0,80201758 <kalloc+0x19c>
    80201698:	02452703          	lw	a4,36(a0)
    assert(alloc);
    8020169c:	00004897          	auipc	a7,0x4
    802016a0:	f7c88893          	addi	a7,a7,-132 # 80205618 <e_text+0x618>
    802016a4:	08f00813          	li	a6,143
    802016a8:	00004797          	auipc	a5,0x4
    802016ac:	db878793          	addi	a5,a5,-584 # 80205460 <e_text+0x460>
    802016b0:	00048693          	mv	a3,s1
    802016b4:	00004617          	auipc	a2,0x4
    802016b8:	97460613          	addi	a2,a2,-1676 # 80205028 <e_text+0x28>
    802016bc:	01f00593          	li	a1,31
    802016c0:	00004517          	auipc	a0,0x4
    802016c4:	97050513          	addi	a0,a0,-1680 # 80205030 <e_text+0x30>
    802016c8:	00001097          	auipc	ra,0x1
    802016cc:	1bc080e7          	jalr	444(ra) # 80202884 <__panic>
    802016d0:	00020493          	mv	s1,tp
    802016d4:	0004849b          	sext.w	s1,s1
    struct proc *p = curr_proc();
    802016d8:	fffff097          	auipc	ra,0xfffff
    802016dc:	714080e7          	jalr	1812(ra) # 80200dec <curr_proc>
    return p ? p->pid : -1;
    802016e0:	08050063          	beqz	a0,80201760 <kalloc+0x1a4>
    802016e4:	02452703          	lw	a4,36(a0)
        panic("should be guarded by available_count");
    802016e8:	0a300813          	li	a6,163
    802016ec:	00004797          	auipc	a5,0x4
    802016f0:	d7478793          	addi	a5,a5,-652 # 80205460 <e_text+0x460>
    802016f4:	00048693          	mv	a3,s1
    802016f8:	00004617          	auipc	a2,0x4
    802016fc:	93060613          	addi	a2,a2,-1744 # 80205028 <e_text+0x28>
    80201700:	01f00593          	li	a1,31
    80201704:	00004517          	auipc	a0,0x4
    80201708:	f4450513          	addi	a0,a0,-188 # 80205648 <e_text+0x648>
    8020170c:	00001097          	auipc	ra,0x1
    80201710:	178080e7          	jalr	376(ra) # 80202884 <__panic>
    80201714:	00020493          	mv	s1,tp
    80201718:	0004849b          	sext.w	s1,s1
    struct proc *p = curr_proc();
    8020171c:	fffff097          	auipc	ra,0xfffff
    80201720:	6d0080e7          	jalr	1744(ra) # 80200dec <curr_proc>
    return p ? p->pid : -1;
    80201724:	04050263          	beqz	a0,80201768 <kalloc+0x1ac>
    80201728:	02452703          	lw	a4,36(a0)
        panic("unavailable");
    8020172c:	09300813          	li	a6,147
    80201730:	00004797          	auipc	a5,0x4
    80201734:	d3078793          	addi	a5,a5,-720 # 80205460 <e_text+0x460>
    80201738:	00048693          	mv	a3,s1
    8020173c:	00004617          	auipc	a2,0x4
    80201740:	8ec60613          	addi	a2,a2,-1812 # 80205028 <e_text+0x28>
    80201744:	01f00593          	li	a1,31
    80201748:	00004517          	auipc	a0,0x4
    8020174c:	ed850513          	addi	a0,a0,-296 # 80205620 <e_text+0x620>
    80201750:	00001097          	auipc	ra,0x1
    80201754:	134080e7          	jalr	308(ra) # 80202884 <__panic>
    80201758:	fff00713          	li	a4,-1
    8020175c:	f41ff06f          	j	8020169c <kalloc+0xe0>
    80201760:	fff00713          	li	a4,-1
    80201764:	f85ff06f          	j	802016e8 <kalloc+0x12c>
    80201768:	fff00713          	li	a4,-1
    8020176c:	fc1ff06f          	j	8020172c <kalloc+0x170>

0000000080201770 <kfree>:

void kfree(struct allocator *alloc, void *obj) {
    if (obj == NULL)
    80201770:	0a058463          	beqz	a1,80201818 <kfree+0xa8>
void kfree(struct allocator *alloc, void *obj) {
    80201774:	fd010113          	addi	sp,sp,-48
    80201778:	02813023          	sd	s0,32(sp)
    8020177c:	00913c23          	sd	s1,24(sp)
    80201780:	02113423          	sd	ra,40(sp)
    80201784:	01213823          	sd	s2,16(sp)
    80201788:	01313423          	sd	s3,8(sp)
    8020178c:	03010413          	addi	s0,sp,48
    80201790:	00050493          	mv	s1,a0
        return;

    assert(alloc);
    80201794:	08050463          	beqz	a0,8020181c <kfree+0xac>
    // assert(alloc->pool_base <= (uint64)obj && (uint64)obj < alloc->pool_end);

    memset(obj, 0xfa, alloc->object_size);
    80201798:	03052603          	lw	a2,48(a0)
    8020179c:	00058913          	mv	s2,a1
    802017a0:	00090513          	mv	a0,s2
    802017a4:	0fa00593          	li	a1,250
    802017a8:	00003097          	auipc	ra,0x3
    802017ac:	af8080e7          	jalr	-1288(ra) # 802042a0 <memset>

    acquire(&alloc->lock);
    802017b0:	00848993          	addi	s3,s1,8
    802017b4:	00098513          	mv	a0,s3
    802017b8:	00000097          	auipc	ra,0x0
    802017bc:	344080e7          	jalr	836(ra) # 80201afc <acquire>
    // put the object back to the freelist.
    struct linklist *l = (struct linklist *)((uint64)obj - sizeof(*l));
    l->next            = alloc->freelist;
    alloc->freelist    = l;

    alloc->allocated_count--;
    802017c0:	0404b783          	ld	a5,64(s1)
    alloc->available_count++;
    802017c4:	0484b703          	ld	a4,72(s1)
    l->next            = alloc->freelist;
    802017c8:	0284b603          	ld	a2,40(s1)
    assert(alloc->allocated_count + alloc->available_count == alloc->max_count);
    802017cc:	0504b683          	ld	a3,80(s1)
    alloc->allocated_count--;
    802017d0:	fff78793          	addi	a5,a5,-1
    l->next            = alloc->freelist;
    802017d4:	fec93c23          	sd	a2,-8(s2)
    alloc->available_count++;
    802017d8:	00170713          	addi	a4,a4,1
    struct linklist *l = (struct linklist *)((uint64)obj - sizeof(*l));
    802017dc:	ff890913          	addi	s2,s2,-8
    alloc->allocated_count--;
    802017e0:	04f4b023          	sd	a5,64(s1)
    alloc->freelist    = l;
    802017e4:	0324b423          	sd	s2,40(s1)
    alloc->available_count++;
    802017e8:	04e4b423          	sd	a4,72(s1)
    assert(alloc->allocated_count + alloc->available_count == alloc->max_count);
    802017ec:	00e787b3          	add	a5,a5,a4
    802017f0:	06d79c63          	bne	a5,a3,80201868 <kfree+0xf8>

    release(&alloc->lock);
    802017f4:	02013403          	ld	s0,32(sp)
    802017f8:	02813083          	ld	ra,40(sp)
    802017fc:	01813483          	ld	s1,24(sp)
    80201800:	01013903          	ld	s2,16(sp)
    release(&alloc->lock);
    80201804:	00098513          	mv	a0,s3
    80201808:	00813983          	ld	s3,8(sp)
    8020180c:	03010113          	addi	sp,sp,48
    release(&alloc->lock);
    80201810:	00000317          	auipc	t1,0x0
    80201814:	43030067          	jr	1072(t1) # 80201c40 <release>
    80201818:	00008067          	ret
    8020181c:	00020493          	mv	s1,tp
    80201820:	0004849b          	sext.w	s1,s1
    struct proc *p = curr_proc();
    80201824:	fffff097          	auipc	ra,0xfffff
    80201828:	5c8080e7          	jalr	1480(ra) # 80200dec <curr_proc>
    return p ? p->pid : -1;
    8020182c:	08050463          	beqz	a0,802018b4 <kfree+0x144>
    80201830:	02452703          	lw	a4,36(a0)
    assert(alloc);
    80201834:	00004897          	auipc	a7,0x4
    80201838:	de488893          	addi	a7,a7,-540 # 80205618 <e_text+0x618>
    8020183c:	0b000813          	li	a6,176
    80201840:	00004797          	auipc	a5,0x4
    80201844:	c2078793          	addi	a5,a5,-992 # 80205460 <e_text+0x460>
    80201848:	00048693          	mv	a3,s1
    8020184c:	00003617          	auipc	a2,0x3
    80201850:	7dc60613          	addi	a2,a2,2012 # 80205028 <e_text+0x28>
    80201854:	01f00593          	li	a1,31
    80201858:	00003517          	auipc	a0,0x3
    8020185c:	7d850513          	addi	a0,a0,2008 # 80205030 <e_text+0x30>
    80201860:	00001097          	auipc	ra,0x1
    80201864:	024080e7          	jalr	36(ra) # 80202884 <__panic>
    80201868:	00020493          	mv	s1,tp
    8020186c:	0004849b          	sext.w	s1,s1
    struct proc *p = curr_proc();
    80201870:	fffff097          	auipc	ra,0xfffff
    80201874:	57c080e7          	jalr	1404(ra) # 80200dec <curr_proc>
    return p ? p->pid : -1;
    80201878:	04050263          	beqz	a0,802018bc <kfree+0x14c>
    8020187c:	02452703          	lw	a4,36(a0)
    assert(alloc->allocated_count + alloc->available_count == alloc->max_count);
    80201880:	00004897          	auipc	a7,0x4
    80201884:	e1088893          	addi	a7,a7,-496 # 80205690 <e_text+0x690>
    80201888:	0be00813          	li	a6,190
    8020188c:	00004797          	auipc	a5,0x4
    80201890:	bd478793          	addi	a5,a5,-1068 # 80205460 <e_text+0x460>
    80201894:	00048693          	mv	a3,s1
    80201898:	00003617          	auipc	a2,0x3
    8020189c:	79060613          	addi	a2,a2,1936 # 80205028 <e_text+0x28>
    802018a0:	01f00593          	li	a1,31
    802018a4:	00003517          	auipc	a0,0x3
    802018a8:	78c50513          	addi	a0,a0,1932 # 80205030 <e_text+0x30>
    802018ac:	00001097          	auipc	ra,0x1
    802018b0:	fd8080e7          	jalr	-40(ra) # 80202884 <__panic>
    802018b4:	fff00713          	li	a4,-1
    802018b8:	f7dff06f          	j	80201834 <kfree+0xc4>
    802018bc:	fff00713          	li	a4,-1
    802018c0:	fc1ff06f          	j	80201880 <kfree+0x110>

00000000802018c4 <spinlock_init>:
#include "lock.h"

#include "defs.h"

void spinlock_init(spinlock_t *lk, char *name)
{
    802018c4:	fe010113          	addi	sp,sp,-32
    802018c8:	00813823          	sd	s0,16(sp)
    802018cc:	00913423          	sd	s1,8(sp)
    802018d0:	01213023          	sd	s2,0(sp)
    802018d4:	00113c23          	sd	ra,24(sp)
    802018d8:	02010413          	addi	s0,sp,32
    802018dc:	00058913          	mv	s2,a1
	memset(lk, 0, sizeof(*lk));
    802018e0:	02000613          	li	a2,32
    802018e4:	00000593          	li	a1,0
{
    802018e8:	00050493          	mv	s1,a0
	memset(lk, 0, sizeof(*lk));
    802018ec:	00003097          	auipc	ra,0x3
    802018f0:	9b4080e7          	jalr	-1612(ra) # 802042a0 <memset>
	lk->name = name;
	lk->locked = 0;
	lk->cpu = 0;
}
    802018f4:	01813083          	ld	ra,24(sp)
    802018f8:	01013403          	ld	s0,16(sp)
	lk->name = name;
    802018fc:	0124b423          	sd	s2,8(s1)
	lk->locked = 0;
    80201900:	0004b023          	sd	zero,0(s1)
	lk->cpu = 0;
    80201904:	0004b823          	sd	zero,16(s1)
}
    80201908:	00013903          	ld	s2,0(sp)
    8020190c:	00813483          	ld	s1,8(sp)
    80201910:	02010113          	addi	sp,sp,32
    80201914:	00008067          	ret

0000000080201918 <holding>:
// Check whether this cpu is holding the lock.
// Interrupts must be off.
int holding(spinlock_t *lk)
{
	int r;
	r = (lk->locked && lk->cpu == mycpu());
    80201918:	00053783          	ld	a5,0(a0)
    8020191c:	00079663          	bnez	a5,80201928 <holding+0x10>
    80201920:	00000513          	li	a0,0
	return r;
}
    80201924:	00008067          	ret
{
    80201928:	fe010113          	addi	sp,sp,-32
    8020192c:	00813823          	sd	s0,16(sp)
    80201930:	00913423          	sd	s1,8(sp)
    80201934:	00113c23          	sd	ra,24(sp)
    80201938:	02010413          	addi	s0,sp,32
	r = (lk->locked && lk->cpu == mycpu());
    8020193c:	01053483          	ld	s1,16(a0)
    80201940:	00002097          	auipc	ra,0x2
    80201944:	7ac080e7          	jalr	1964(ra) # 802040ec <mycpu>
}
    80201948:	01813083          	ld	ra,24(sp)
    8020194c:	01013403          	ld	s0,16(sp)
	r = (lk->locked && lk->cpu == mycpu());
    80201950:	40a48533          	sub	a0,s1,a0
    80201954:	00153513          	seqz	a0,a0
}
    80201958:	00813483          	ld	s1,8(sp)
    8020195c:	02010113          	addi	sp,sp,32
    80201960:	00008067          	ret

0000000080201964 <push_off>:
// push_off/pop_off are like intr_off()/intr_on() except that they are matched:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void push_off(void)
{
    80201964:	fe010113          	addi	sp,sp,-32
    80201968:	00813823          	sd	s0,16(sp)
    8020196c:	00113c23          	sd	ra,24(sp)
    80201970:	00913423          	sd	s1,8(sp)
    80201974:	02010413          	addi	s0,sp,32
    asm volatile("mv %0, ra" : "=r"(x));
    80201978:	00008793          	mv	a5,ra
    asm volatile("csrr %0, sstatus" : "=r"(x));
    8020197c:	100024f3          	csrr	s1,sstatus
    asm volatile("csrrc %0, sstatus, %1" : "=r"(prev) : "r"(SSTATUS_SIE));
    80201980:	00200793          	li	a5,2
    80201984:	1007b7f3          	csrrc	a5,sstatus,a5
	uint64 ra = r_ra();

	int old = intr_get();
	intr_off();

	if (mycpu()->noff == 0) {
    80201988:	00002097          	auipc	ra,0x2
    8020198c:	764080e7          	jalr	1892(ra) # 802040ec <mycpu>
    80201990:	08452783          	lw	a5,132(a0)
    80201994:	02078663          	beqz	a5,802019c0 <push_off+0x5c>
		// warnf("intr on saved: %p", ra);
		mycpu()->interrupt_on = old;
	}
	mycpu()->noff += 1;
    80201998:	00002097          	auipc	ra,0x2
    8020199c:	754080e7          	jalr	1876(ra) # 802040ec <mycpu>
    802019a0:	08452783          	lw	a5,132(a0)
}
    802019a4:	01813083          	ld	ra,24(sp)
    802019a8:	01013403          	ld	s0,16(sp)
	mycpu()->noff += 1;
    802019ac:	0017879b          	addiw	a5,a5,1
    802019b0:	08f52223          	sw	a5,132(a0)
}
    802019b4:	00813483          	ld	s1,8(sp)
    802019b8:	02010113          	addi	sp,sp,32
    802019bc:	00008067          	ret
    return (x & SSTATUS_SIE) != 0;
    802019c0:	0014d493          	srli	s1,s1,0x1
		mycpu()->interrupt_on = old;
    802019c4:	00002097          	auipc	ra,0x2
    802019c8:	728080e7          	jalr	1832(ra) # 802040ec <mycpu>
    802019cc:	0014f493          	andi	s1,s1,1
    802019d0:	08952423          	sw	s1,136(a0)
    802019d4:	fc5ff06f          	j	80201998 <push_off+0x34>

00000000802019d8 <pop_off>:

void pop_off(void)
{
    802019d8:	fe010113          	addi	sp,sp,-32
    802019dc:	00813823          	sd	s0,16(sp)
    802019e0:	00113c23          	sd	ra,24(sp)
    802019e4:	02010413          	addi	s0,sp,32
    asm volatile("mv %0, ra" : "=r"(x));
    802019e8:	00008793          	mv	a5,ra
	uint64 ra = r_ra();

	struct cpu *c = mycpu();
    802019ec:	00002097          	auipc	ra,0x2
    802019f0:	700080e7          	jalr	1792(ra) # 802040ec <mycpu>
    asm volatile("csrr %0, sstatus" : "=r"(x));
    802019f4:	100027f3          	csrr	a5,sstatus
    return (x & SSTATUS_SIE) != 0;
    802019f8:	0027f793          	andi	a5,a5,2
	if (intr_get())
    802019fc:	08079063          	bnez	a5,80201a7c <pop_off+0xa4>
		panic("pop_off - interruptible");
	if (c->noff < 1)
    80201a00:	08452783          	lw	a5,132(a0)
    80201a04:	02f05c63          	blez	a5,80201a3c <pop_off+0x64>
		panic("pop_off - unpair");
	c->noff -= 1;
    80201a08:	fff7871b          	addiw	a4,a5,-1
    80201a0c:	08e52223          	sw	a4,132(a0)
	if (c->noff == 0 && c->interrupt_on) {
    80201a10:	00071e63          	bnez	a4,80201a2c <pop_off+0x54>
    80201a14:	08852783          	lw	a5,136(a0)
    80201a18:	00078a63          	beqz	a5,80201a2c <pop_off+0x54>
		if (c->inkernel_trap)
    80201a1c:	08052783          	lw	a5,128(a0)
    80201a20:	08079e63          	bnez	a5,80201abc <pop_off+0xe4>
    asm volatile("csrrs x0, sstatus, %0" ::"r"(SSTATUS_SIE));
    80201a24:	00200793          	li	a5,2
    80201a28:	1007a073          	csrs	sstatus,a5
			panic("pop_off->intr_on happens in kernel trap");
		intr_on();
	}
}
    80201a2c:	01813083          	ld	ra,24(sp)
    80201a30:	01013403          	ld	s0,16(sp)
    80201a34:	02010113          	addi	sp,sp,32
    80201a38:	00008067          	ret
    asm volatile("mv %0, tp" : "=r"(x));
    80201a3c:	00913423          	sd	s1,8(sp)
    80201a40:	00020493          	mv	s1,tp
		panic("pop_off - unpair");
    80201a44:	00000097          	auipc	ra,0x0
    80201a48:	1a8080e7          	jalr	424(ra) # 80201bec <__safe_pid>
    80201a4c:	00050713          	mv	a4,a0
    80201a50:	06800813          	li	a6,104
    80201a54:	00004797          	auipc	a5,0x4
    80201a58:	c8478793          	addi	a5,a5,-892 # 802056d8 <e_text+0x6d8>
    80201a5c:	0004869b          	sext.w	a3,s1
    80201a60:	00003617          	auipc	a2,0x3
    80201a64:	5c860613          	addi	a2,a2,1480 # 80205028 <e_text+0x28>
    80201a68:	01f00593          	li	a1,31
    80201a6c:	00004517          	auipc	a0,0x4
    80201a70:	cb450513          	addi	a0,a0,-844 # 80205720 <e_text+0x720>
    80201a74:	00001097          	auipc	ra,0x1
    80201a78:	e10080e7          	jalr	-496(ra) # 80202884 <__panic>
    80201a7c:	00913423          	sd	s1,8(sp)
    80201a80:	00020493          	mv	s1,tp
		panic("pop_off - interruptible");
    80201a84:	00000097          	auipc	ra,0x0
    80201a88:	168080e7          	jalr	360(ra) # 80201bec <__safe_pid>
    80201a8c:	00050713          	mv	a4,a0
    80201a90:	06600813          	li	a6,102
    80201a94:	00004797          	auipc	a5,0x4
    80201a98:	c4478793          	addi	a5,a5,-956 # 802056d8 <e_text+0x6d8>
    80201a9c:	0004869b          	sext.w	a3,s1
    80201aa0:	00003617          	auipc	a2,0x3
    80201aa4:	58860613          	addi	a2,a2,1416 # 80205028 <e_text+0x28>
    80201aa8:	01f00593          	li	a1,31
    80201aac:	00004517          	auipc	a0,0x4
    80201ab0:	c3c50513          	addi	a0,a0,-964 # 802056e8 <e_text+0x6e8>
    80201ab4:	00001097          	auipc	ra,0x1
    80201ab8:	dd0080e7          	jalr	-560(ra) # 80202884 <__panic>
    80201abc:	00913423          	sd	s1,8(sp)
    80201ac0:	00020493          	mv	s1,tp
			panic("pop_off->intr_on happens in kernel trap");
    80201ac4:	00000097          	auipc	ra,0x0
    80201ac8:	128080e7          	jalr	296(ra) # 80201bec <__safe_pid>
    80201acc:	00050713          	mv	a4,a0
    80201ad0:	06c00813          	li	a6,108
    80201ad4:	00004797          	auipc	a5,0x4
    80201ad8:	c0478793          	addi	a5,a5,-1020 # 802056d8 <e_text+0x6d8>
    80201adc:	0004869b          	sext.w	a3,s1
    80201ae0:	00003617          	auipc	a2,0x3
    80201ae4:	54860613          	addi	a2,a2,1352 # 80205028 <e_text+0x28>
    80201ae8:	01f00593          	li	a1,31
    80201aec:	00004517          	auipc	a0,0x4
    80201af0:	c6450513          	addi	a0,a0,-924 # 80205750 <e_text+0x750>
    80201af4:	00001097          	auipc	ra,0x1
    80201af8:	d90080e7          	jalr	-624(ra) # 80202884 <__panic>

0000000080201afc <acquire>:
{
    80201afc:	fc010113          	addi	sp,sp,-64
    80201b00:	02813823          	sd	s0,48(sp)
    80201b04:	02913423          	sd	s1,40(sp)
    80201b08:	02113c23          	sd	ra,56(sp)
    80201b0c:	03213023          	sd	s2,32(sp)
    80201b10:	04010413          	addi	s0,sp,64
    80201b14:	00050493          	mv	s1,a0
    asm volatile("mv %0, ra" : "=r"(x));
    80201b18:	00008913          	mv	s2,ra
	push_off(); // disable interrupts to avoid deadlock.
    80201b1c:	00000097          	auipc	ra,0x0
    80201b20:	e48080e7          	jalr	-440(ra) # 80201964 <push_off>
	r = (lk->locked && lk->cpu == mycpu());
    80201b24:	0004b783          	ld	a5,0(s1)
    80201b28:	04079063          	bnez	a5,80201b68 <acquire+0x6c>
	while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80201b2c:	00100713          	li	a4,1
    80201b30:	00070793          	mv	a5,a4
    80201b34:	0cf4b7af          	amoswap.d.aq	a5,a5,(s1)
    80201b38:	fe079ce3          	bnez	a5,80201b30 <acquire+0x34>
	__sync_synchronize();
    80201b3c:	0ff0000f          	fence
	lk->cpu = mycpu();
    80201b40:	00002097          	auipc	ra,0x2
    80201b44:	5ac080e7          	jalr	1452(ra) # 802040ec <mycpu>
}
    80201b48:	03813083          	ld	ra,56(sp)
    80201b4c:	03013403          	ld	s0,48(sp)
	lk->where = (void *)ra;
    80201b50:	0124bc23          	sd	s2,24(s1)
	lk->cpu = mycpu();
    80201b54:	00a4b823          	sd	a0,16(s1)
}
    80201b58:	02013903          	ld	s2,32(sp)
    80201b5c:	02813483          	ld	s1,40(sp)
    80201b60:	04010113          	addi	sp,sp,64
    80201b64:	00008067          	ret
    80201b68:	01313c23          	sd	s3,24(sp)
	r = (lk->locked && lk->cpu == mycpu());
    80201b6c:	0104b983          	ld	s3,16(s1)
    80201b70:	00002097          	auipc	ra,0x2
    80201b74:	57c080e7          	jalr	1404(ra) # 802040ec <mycpu>
    80201b78:	00a98663          	beq	s3,a0,80201b84 <acquire+0x88>
    80201b7c:	01813983          	ld	s3,24(sp)
    80201b80:	fadff06f          	j	80201b2c <acquire+0x30>
    asm volatile("mv %0, tp" : "=r"(x));
    80201b84:	01413823          	sd	s4,16(sp)
    80201b88:	00020a13          	mv	s4,tp
    push_off();
    80201b8c:	00000097          	auipc	ra,0x0
    80201b90:	dd8080e7          	jalr	-552(ra) # 80201964 <push_off>
    struct cpu* c = mycpu();
    80201b94:	00002097          	auipc	ra,0x2
    80201b98:	558080e7          	jalr	1368(ra) # 802040ec <mycpu>
    struct proc* p = c->proc;
    80201b9c:	00853983          	ld	s3,8(a0)
    pop_off();
    80201ba0:	00000097          	auipc	ra,0x0
    80201ba4:	e38080e7          	jalr	-456(ra) # 802019d8 <pop_off>
    80201ba8:	00098663          	beqz	s3,80201bb4 <acquire+0xb8>
    80201bac:	0249a703          	lw	a4,36(s3)
    80201bb0:	0080006f          	j	80201bb8 <acquire+0xbc>
    80201bb4:	fff00713          	li	a4,-1
		panic("already acquired by %p, now %p", lk->where, ra);
    80201bb8:	0184b883          	ld	a7,24(s1)
    80201bbc:	01400813          	li	a6,20
    80201bc0:	01213023          	sd	s2,0(sp)
    80201bc4:	00004797          	auipc	a5,0x4
    80201bc8:	b1478793          	addi	a5,a5,-1260 # 802056d8 <e_text+0x6d8>
    80201bcc:	000a069b          	sext.w	a3,s4
    80201bd0:	00003617          	auipc	a2,0x3
    80201bd4:	45860613          	addi	a2,a2,1112 # 80205028 <e_text+0x28>
    80201bd8:	01f00593          	li	a1,31
    80201bdc:	00004517          	auipc	a0,0x4
    80201be0:	bbc50513          	addi	a0,a0,-1092 # 80205798 <e_text+0x798>
    80201be4:	00001097          	auipc	ra,0x1
    80201be8:	ca0080e7          	jalr	-864(ra) # 80202884 <__panic>

0000000080201bec <__safe_pid>:
static inline int __safe_pid() {
    80201bec:	fe010113          	addi	sp,sp,-32
    80201bf0:	00113c23          	sd	ra,24(sp)
    80201bf4:	00813823          	sd	s0,16(sp)
    80201bf8:	00913423          	sd	s1,8(sp)
    80201bfc:	02010413          	addi	s0,sp,32
    push_off();
    80201c00:	00000097          	auipc	ra,0x0
    80201c04:	d64080e7          	jalr	-668(ra) # 80201964 <push_off>
    struct cpu* c = mycpu();
    80201c08:	00002097          	auipc	ra,0x2
    80201c0c:	4e4080e7          	jalr	1252(ra) # 802040ec <mycpu>
    struct proc* p = c->proc;
    80201c10:	00853483          	ld	s1,8(a0)
    pop_off();
    80201c14:	00000097          	auipc	ra,0x0
    80201c18:	dc4080e7          	jalr	-572(ra) # 802019d8 <pop_off>
    return p ? p->pid : -1;
    80201c1c:	00048e63          	beqz	s1,80201c38 <__safe_pid+0x4c>
    80201c20:	0244a503          	lw	a0,36(s1)
}
    80201c24:	01813083          	ld	ra,24(sp)
    80201c28:	01013403          	ld	s0,16(sp)
    80201c2c:	00813483          	ld	s1,8(sp)
    80201c30:	02010113          	addi	sp,sp,32
    80201c34:	00008067          	ret
    return p ? p->pid : -1;
    80201c38:	fff00513          	li	a0,-1
    80201c3c:	fe9ff06f          	j	80201c24 <__safe_pid+0x38>

0000000080201c40 <release>:
{
    80201c40:	fe010113          	addi	sp,sp,-32
    80201c44:	00813823          	sd	s0,16(sp)
    80201c48:	00113c23          	sd	ra,24(sp)
    80201c4c:	00913423          	sd	s1,8(sp)
    80201c50:	01213023          	sd	s2,0(sp)
    80201c54:	02010413          	addi	s0,sp,32
	r = (lk->locked && lk->cpu == mycpu());
    80201c58:	00053783          	ld	a5,0(a0)
    80201c5c:	04079c63          	bnez	a5,80201cb4 <release+0x74>
    80201c60:	00020913          	mv	s2,tp
    push_off();
    80201c64:	00000097          	auipc	ra,0x0
    80201c68:	d00080e7          	jalr	-768(ra) # 80201964 <push_off>
    struct cpu* c = mycpu();
    80201c6c:	00002097          	auipc	ra,0x2
    80201c70:	480080e7          	jalr	1152(ra) # 802040ec <mycpu>
    struct proc* p = c->proc;
    80201c74:	00853483          	ld	s1,8(a0)
    pop_off();
    80201c78:	00000097          	auipc	ra,0x0
    80201c7c:	d60080e7          	jalr	-672(ra) # 802019d8 <pop_off>
    80201c80:	06048c63          	beqz	s1,80201cf8 <release+0xb8>
    80201c84:	0244a703          	lw	a4,36(s1)
		panic("release");
    80201c88:	02c00813          	li	a6,44
    80201c8c:	00004797          	auipc	a5,0x4
    80201c90:	a4c78793          	addi	a5,a5,-1460 # 802056d8 <e_text+0x6d8>
    80201c94:	0009069b          	sext.w	a3,s2
    80201c98:	00003617          	auipc	a2,0x3
    80201c9c:	39060613          	addi	a2,a2,912 # 80205028 <e_text+0x28>
    80201ca0:	01f00593          	li	a1,31
    80201ca4:	00004517          	auipc	a0,0x4
    80201ca8:	b3450513          	addi	a0,a0,-1228 # 802057d8 <e_text+0x7d8>
    80201cac:	00001097          	auipc	ra,0x1
    80201cb0:	bd8080e7          	jalr	-1064(ra) # 80202884 <__panic>
	r = (lk->locked && lk->cpu == mycpu());
    80201cb4:	01053903          	ld	s2,16(a0)
    80201cb8:	00050493          	mv	s1,a0
    80201cbc:	00002097          	auipc	ra,0x2
    80201cc0:	430080e7          	jalr	1072(ra) # 802040ec <mycpu>
    80201cc4:	f8a91ee3          	bne	s2,a0,80201c60 <release+0x20>
	lk->cpu = 0;
    80201cc8:	0004b823          	sd	zero,16(s1)
	lk->where = 0;
    80201ccc:	0004bc23          	sd	zero,24(s1)
	__sync_synchronize();
    80201cd0:	0ff0000f          	fence
	__sync_lock_release(&lk->locked);
    80201cd4:	0f50000f          	fence	iorw,ow
    80201cd8:	0804b02f          	amoswap.d	zero,zero,(s1)
}
    80201cdc:	01013403          	ld	s0,16(sp)
    80201ce0:	01813083          	ld	ra,24(sp)
    80201ce4:	00813483          	ld	s1,8(sp)
    80201ce8:	00013903          	ld	s2,0(sp)
    80201cec:	02010113          	addi	sp,sp,32
	pop_off();
    80201cf0:	00000317          	auipc	t1,0x0
    80201cf4:	ce830067          	jr	-792(t1) # 802019d8 <pop_off>
    80201cf8:	fff00713          	li	a4,-1
    80201cfc:	f8dff06f          	j	80201c88 <release+0x48>

0000000080201d00 <curr_proc>:
 *    |   uvm, proc, loader                                 |
 *    |                                                     |
 *    | halt_init: trap, timer, plic_hart                   | halt_init: trap, timer, plic_hart
 *    |                                                     |
 * -------------                                    -------------
 * | scheduler |                                    | scheduler |
    80201d00:	fe010113          	addi	sp,sp,-32
    80201d04:	00113c23          	sd	ra,24(sp)
    80201d08:	00813823          	sd	s0,16(sp)
    80201d0c:	00913423          	sd	s1,8(sp)
    80201d10:	02010413          	addi	s0,sp,32
 * -------------                                    -------------
    80201d14:	00000097          	auipc	ra,0x0
    80201d18:	c50080e7          	jalr	-944(ra) # 80201964 <push_off>
 */
    80201d1c:	00002097          	auipc	ra,0x2
    80201d20:	3d0080e7          	jalr	976(ra) # 802040ec <mycpu>

    80201d24:	00853483          	ld	s1,8(a0)
void bootcpu_entry(int mhartid) {
    80201d28:	00000097          	auipc	ra,0x0
    80201d2c:	cb0080e7          	jalr	-848(ra) # 802019d8 <pop_off>
    printf("\n\n=====\nHello World!\n=====\n\n");
    printf("Boot stack: %p\nclean bss: %p - %p\n", boot_stack, s_bss, e_bss);
    80201d30:	01813083          	ld	ra,24(sp)
    80201d34:	01013403          	ld	s0,16(sp)
    80201d38:	00048513          	mv	a0,s1
    80201d3c:	00813483          	ld	s1,8(sp)
    80201d40:	02010113          	addi	sp,sp,32
    80201d44:	00008067          	ret

0000000080201d48 <bootcpu_init>:
    asm volatile("jr a1");

    __builtin_unreachable();
}

static void bootcpu_init() {
    80201d48:	fa010113          	addi	sp,sp,-96
    80201d4c:	04813823          	sd	s0,80(sp)
    80201d50:	04113c23          	sd	ra,88(sp)
    80201d54:	04913423          	sd	s1,72(sp)
    80201d58:	05213023          	sd	s2,64(sp)
    80201d5c:	03313c23          	sd	s3,56(sp)
    80201d60:	03413823          	sd	s4,48(sp)
    80201d64:	03513423          	sd	s5,40(sp)
    80201d68:	03613023          	sd	s6,32(sp)
    80201d6c:	01713c23          	sd	s7,24(sp)
    80201d70:	01813823          	sd	s8,16(sp)
    80201d74:	01913423          	sd	s9,8(sp)
    80201d78:	01a13023          	sd	s10,0(sp)
    80201d7c:	06010413          	addi	s0,sp,96
    asm volatile("mv %0, sp" : "=r"(x));
    80201d80:	00010593          	mv	a1,sp
    printf("Relocated. Boot halt sp at %p\n", r_sp());
    80201d84:	00004517          	auipc	a0,0x4
    80201d88:	a7c50513          	addi	a0,a0,-1412 # 80205800 <e_text+0x800>
    80201d8c:	00001097          	auipc	ra,0x1
    80201d90:	df8080e7          	jalr	-520(ra) # 80202b84 <printf>

#ifdef ENABLE_SMP
    printf("Boot another cpus.\n");
    80201d94:	00004517          	auipc	a0,0x4
    80201d98:	a8c50513          	addi	a0,a0,-1396 # 80205820 <e_text+0x820>
    80201d9c:	00001097          	auipc	ra,0x1
    80201da0:	de8080e7          	jalr	-536(ra) # 80202b84 <printf>
    80201da4:	00000993          	li	s3,0

    // Attention: OpenSBI does not guarantee the boot cpu has mhartid == 0.
    // We assume NCPU == the number of cpus in the system, although spec does not guarantee this.
    {
        int cpuid = 1;
    80201da8:	00100a93          	li	s5,1
        for (int hartid = 0; hartid < NCPU; hartid++) {
            if (hartid == mycpu()->mhart_id)
                continue;

            int saved_booted_cnt = booted_count;
    80201dac:	0001c917          	auipc	s2,0x1c
    80201db0:	5c090913          	addi	s2,s2,1472 # 8021e36c <booted_count>

            printf("- booting hart %d: hsm_hart_start(hartid=%d, pc=_entry_sec, opaque=%d)", hartid, hartid, cpuid);
    80201db4:	00004c97          	auipc	s9,0x4
    80201db8:	a84c8c93          	addi	s9,s9,-1404 # 80205838 <e_text+0x838>
            int ret = sbi_hsm_hart_start(hartid, (uint64)_entry_secondary_cpu, cpuid);
    80201dbc:	ffffec17          	auipc	s8,0xffffe
    80201dc0:	254c0c13          	addi	s8,s8,596 # 80200010 <_entry_secondary_cpu>
            printf(" = %d. waiting for hart online\n", ret);
    80201dc4:	00004b97          	auipc	s7,0x4
    80201dc8:	abcb8b93          	addi	s7,s7,-1348 # 80205880 <e_text+0x880>
        for (int hartid = 0; hartid < NCPU; hartid++) {
    80201dcc:	00400b13          	li	s6,4
            if (hartid == mycpu()->mhart_id)
    80201dd0:	00002097          	auipc	ra,0x2
    80201dd4:	31c080e7          	jalr	796(ra) # 802040ec <mycpu>
    80201dd8:	00052783          	lw	a5,0(a0)
    80201ddc:	00098a1b          	sext.w	s4,s3
    80201de0:	05478e63          	beq	a5,s4,80201e3c <bootcpu_init+0xf4>
            printf("- booting hart %d: hsm_hart_start(hartid=%d, pc=_entry_sec, opaque=%d)", hartid, hartid, cpuid);
    80201de4:	000a8693          	mv	a3,s5
    80201de8:	000a0613          	mv	a2,s4
    80201dec:	000a0593          	mv	a1,s4
    80201df0:	000c8513          	mv	a0,s9
            int saved_booted_cnt = booted_count;
    80201df4:	00092483          	lw	s1,0(s2)
            printf("- booting hart %d: hsm_hart_start(hartid=%d, pc=_entry_sec, opaque=%d)", hartid, hartid, cpuid);
    80201df8:	00001097          	auipc	ra,0x1
    80201dfc:	d8c080e7          	jalr	-628(ra) # 80202b84 <printf>
            int ret = sbi_hsm_hart_start(hartid, (uint64)_entry_secondary_cpu, cpuid);
    80201e00:	000c0593          	mv	a1,s8
    80201e04:	000a8613          	mv	a2,s5
    80201e08:	00098513          	mv	a0,s3
    80201e0c:	00002097          	auipc	ra,0x2
    80201e10:	a60080e7          	jalr	-1440(ra) # 8020386c <sbi_hsm_hart_start>
    80201e14:	00050d13          	mv	s10,a0
            printf(" = %d. waiting for hart online\n", ret);
    80201e18:	00050593          	mv	a1,a0
    80201e1c:	000b8513          	mv	a0,s7
            int saved_booted_cnt = booted_count;
    80201e20:	0004849b          	sext.w	s1,s1
            printf(" = %d. waiting for hart online\n", ret);
    80201e24:	00001097          	auipc	ra,0x1
    80201e28:	d60080e7          	jalr	-672(ra) # 80202b84 <printf>
            if (ret < 0) {
    80201e2c:	100d4a63          	bltz	s10,80201f40 <bootcpu_init+0x1f8>
                printf("skipped for hart %d\n", hartid);
                continue;
            }
            while (booted_count == saved_booted_cnt);
    80201e30:	00092783          	lw	a5,0(s2)
    80201e34:	fe978ee3          	beq	a5,s1,80201e30 <bootcpu_init+0xe8>
            cpuid++;
    80201e38:	001a8a9b          	addiw	s5,s5,1
        for (int hartid = 0; hartid < NCPU; hartid++) {
    80201e3c:	00198993          	addi	s3,s3,1
    80201e40:	f96998e3          	bne	s3,s6,80201dd0 <bootcpu_init+0x88>
        }
        printf("System has %d cpus online\n\n", cpuid);
    80201e44:	000a8593          	mv	a1,s5
    80201e48:	00004517          	auipc	a0,0x4
    80201e4c:	a7050513          	addi	a0,a0,-1424 # 802058b8 <e_text+0x8b8>
    80201e50:	00001097          	auipc	ra,0x1
    80201e54:	d34080e7          	jalr	-716(ra) # 80202b84 <printf>
    }
#endif

    trap_init();
    80201e58:	00003097          	auipc	ra,0x3
    80201e5c:	de0080e7          	jalr	-544(ra) # 80204c38 <trap_init>
    console_init();
    80201e60:	ffffe097          	auipc	ra,0xffffe
    80201e64:	458080e7          	jalr	1112(ra) # 802002b8 <console_init>
    printf("UART inited.\n");
    80201e68:	00004517          	auipc	a0,0x4
    80201e6c:	a7050513          	addi	a0,a0,-1424 # 802058d8 <e_text+0x8d8>
    80201e70:	00001097          	auipc	ra,0x1
    80201e74:	d14080e7          	jalr	-748(ra) # 80202b84 <printf>
    plicinit();
    80201e78:	00001097          	auipc	ra,0x1
    80201e7c:	844080e7          	jalr	-1980(ra) # 802026bc <plicinit>

    // NOMMU: we need to set kpage_allocator_base and kpage_allocator_size
    kpage_allocator_base = PGROUNDUP((uint64)ekernel);
    80201e80:	fffff6b7          	lui	a3,0xfffff
    kpage_allocator_size = PGROUNDUP(RISCV_DDR_BASE + PHYS_MEM_SIZE) - kpage_allocator_base;
    80201e84:	02100793          	li	a5,33
    kpage_allocator_base = PGROUNDUP((uint64)ekernel);
    80201e88:	0001e717          	auipc	a4,0x1e
    80201e8c:	17770713          	addi	a4,a4,375 # 8021ffff <e_bss+0xfff>
    80201e90:	00d77733          	and	a4,a4,a3
    kpage_allocator_size = PGROUNDUP(RISCV_DDR_BASE + PHYS_MEM_SIZE) - kpage_allocator_base;
    80201e94:	01a79793          	slli	a5,a5,0x1a
    80201e98:	40e787b3          	sub	a5,a5,a4
    kpage_allocator_base = PGROUNDUP((uint64)ekernel);
    80201e9c:	0001c697          	auipc	a3,0x1c
    80201ea0:	4ce6be23          	sd	a4,1244(a3) # 8021e378 <kpage_allocator_base>
    kpage_allocator_size = PGROUNDUP(RISCV_DDR_BASE + PHYS_MEM_SIZE) - kpage_allocator_base;
    80201ea4:	0001c717          	auipc	a4,0x1c
    80201ea8:	4cf73623          	sd	a5,1228(a4) # 8021e370 <kpage_allocator_size>

    kpgmgrinit();
    80201eac:	fffff097          	auipc	ra,0xfffff
    80201eb0:	0b8080e7          	jalr	184(ra) # 80200f64 <kpgmgrinit>
    proc_init();
    80201eb4:	00001097          	auipc	ra,0x1
    80201eb8:	df4080e7          	jalr	-524(ra) # 80202ca8 <proc_init>
    timer_init();
    80201ebc:	00002097          	auipc	ra,0x2
    80201ec0:	6e0080e7          	jalr	1760(ra) # 8020459c <timer_init>
    plicinithart();
    80201ec4:	00001097          	auipc	ra,0x1
    80201ec8:	81c080e7          	jalr	-2020(ra) # 802026e0 <plicinithart>

    create_kthread(init, 0x1919810);
    80201ecc:	0191a5b7          	lui	a1,0x191a
    80201ed0:	81058593          	addi	a1,a1,-2032 # 1919810 <_entry-0x7e8e67f0>
    80201ed4:	00000517          	auipc	a0,0x0
    80201ed8:	59050513          	addi	a0,a0,1424 # 80202464 <init>
    80201edc:	00001097          	auipc	ra,0x1
    80201ee0:	138080e7          	jalr	312(ra) # 80203014 <create_kthread>

    MEMORY_FENCE();
    80201ee4:	0ff0000f          	fence
    halt_specific_init = 1;
    80201ee8:	00100793          	li	a5,1
    80201eec:	0001c717          	auipc	a4,0x1c
    80201ef0:	46f72e23          	sw	a5,1148(a4) # 8021e368 <halt_specific_init>
    MEMORY_FENCE();
    80201ef4:	0ff0000f          	fence
    asm volatile("mv %0, tp" : "=r"(x));
    80201ef8:	00020493          	mv	s1,tp
    return r_tp();
    80201efc:	0004849b          	sext.w	s1,s1
    struct proc *p = curr_proc();
    80201f00:	00000097          	auipc	ra,0x0
    80201f04:	e00080e7          	jalr	-512(ra) # 80201d00 <curr_proc>
    return p ? p->pid : -1;
    80201f08:	04050863          	beqz	a0,80201f58 <bootcpu_init+0x210>
    80201f0c:	02452703          	lw	a4,36(a0)

    infof("start scheduler!");
    80201f10:	00004797          	auipc	a5,0x4
    80201f14:	32078793          	addi	a5,a5,800 # 80206230 <__func__.1>
    80201f18:	00048693          	mv	a3,s1
    80201f1c:	00003617          	auipc	a2,0x3
    80201f20:	59460613          	addi	a2,a2,1428 # 802054b0 <e_text+0x4b0>
    80201f24:	02200593          	li	a1,34
    80201f28:	00004517          	auipc	a0,0x4
    80201f2c:	9c050513          	addi	a0,a0,-1600 # 802058e8 <e_text+0x8e8>
    80201f30:	00001097          	auipc	ra,0x1
    80201f34:	c54080e7          	jalr	-940(ra) # 80202b84 <printf>
    scheduler();
    80201f38:	00002097          	auipc	ra,0x2
    80201f3c:	afc080e7          	jalr	-1284(ra) # 80203a34 <scheduler>
                printf("skipped for hart %d\n", hartid);
    80201f40:	000a0593          	mv	a1,s4
    80201f44:	00004517          	auipc	a0,0x4
    80201f48:	95c50513          	addi	a0,a0,-1700 # 802058a0 <e_text+0x8a0>
    80201f4c:	00001097          	auipc	ra,0x1
    80201f50:	c38080e7          	jalr	-968(ra) # 80202b84 <printf>
                continue;
    80201f54:	ee9ff06f          	j	80201e3c <bootcpu_init+0xf4>
    80201f58:	fff00713          	li	a4,-1
    80201f5c:	fb5ff06f          	j	80201f10 <bootcpu_init+0x1c8>

0000000080201f60 <secondarycpu_init>:

    assert("scheduler returns");
}

static void secondarycpu_init() {
    80201f60:	fe010113          	addi	sp,sp,-32
    80201f64:	00113c23          	sd	ra,24(sp)
    80201f68:	00813823          	sd	s0,16(sp)
    80201f6c:	00913423          	sd	s1,8(sp)
    80201f70:	02010413          	addi	s0,sp,32
    printf("cpu %d (halt %d) booted. sp: %p\n", mycpu()->cpuid, mycpu()->mhart_id, r_sp());
    80201f74:	00002097          	auipc	ra,0x2
    80201f78:	178080e7          	jalr	376(ra) # 802040ec <mycpu>
    80201f7c:	09852483          	lw	s1,152(a0)
    80201f80:	00002097          	auipc	ra,0x2
    80201f84:	16c080e7          	jalr	364(ra) # 802040ec <mycpu>
    asm volatile("mv %0, sp" : "=r"(x));
    80201f88:	00010693          	mv	a3,sp
    80201f8c:	00052603          	lw	a2,0(a0)
    80201f90:	00048593          	mv	a1,s1
    80201f94:	00004517          	auipc	a0,0x4
    80201f98:	98450513          	addi	a0,a0,-1660 # 80205918 <e_text+0x918>
    80201f9c:	00001097          	auipc	ra,0x1
    80201fa0:	be8080e7          	jalr	-1048(ra) # 80202b84 <printf>
    booted_count++;
    80201fa4:	0001c797          	auipc	a5,0x1c
    80201fa8:	3c87a783          	lw	a5,968(a5) # 8021e36c <booted_count>
    80201fac:	0017879b          	addiw	a5,a5,1
    80201fb0:	0001c717          	auipc	a4,0x1c
    80201fb4:	3af72e23          	sw	a5,956(a4) # 8021e36c <booted_count>
    while (!halt_specific_init);
    80201fb8:	0001c717          	auipc	a4,0x1c
    80201fbc:	3b070713          	addi	a4,a4,944 # 8021e368 <halt_specific_init>
    80201fc0:	00072783          	lw	a5,0(a4)
    80201fc4:	fe078ee3          	beqz	a5,80201fc0 <secondarycpu_init+0x60>

    trap_init();
    80201fc8:	00003097          	auipc	ra,0x3
    80201fcc:	c70080e7          	jalr	-912(ra) # 80204c38 <trap_init>
    timer_init();
    80201fd0:	00002097          	auipc	ra,0x2
    80201fd4:	5cc080e7          	jalr	1484(ra) # 8020459c <timer_init>
    plicinithart();
    80201fd8:	00000097          	auipc	ra,0x0
    80201fdc:	708080e7          	jalr	1800(ra) # 802026e0 <plicinithart>
    asm volatile("mv %0, tp" : "=r"(x));
    80201fe0:	00020493          	mv	s1,tp
    80201fe4:	0004849b          	sext.w	s1,s1
    struct proc *p = curr_proc();
    80201fe8:	00000097          	auipc	ra,0x0
    80201fec:	d18080e7          	jalr	-744(ra) # 80201d00 <curr_proc>
    return p ? p->pid : -1;
    80201ff0:	02050c63          	beqz	a0,80202028 <secondarycpu_init+0xc8>
    80201ff4:	02452703          	lw	a4,36(a0)

    infof("start scheduler!");
    80201ff8:	00004797          	auipc	a5,0x4
    80201ffc:	24878793          	addi	a5,a5,584 # 80206240 <__func__.0>
    80202000:	00048693          	mv	a3,s1
    80202004:	00003617          	auipc	a2,0x3
    80202008:	4ac60613          	addi	a2,a2,1196 # 802054b0 <e_text+0x4b0>
    8020200c:	02200593          	li	a1,34
    80202010:	00004517          	auipc	a0,0x4
    80202014:	8d850513          	addi	a0,a0,-1832 # 802058e8 <e_text+0x8e8>
    80202018:	00001097          	auipc	ra,0x1
    8020201c:	b6c080e7          	jalr	-1172(ra) # 80202b84 <printf>
    scheduler();
    80202020:	00002097          	auipc	ra,0x2
    80202024:	a14080e7          	jalr	-1516(ra) # 80203a34 <scheduler>
    80202028:	fff00713          	li	a4,-1
    8020202c:	fcdff06f          	j	80201ff8 <secondarycpu_init+0x98>

0000000080202030 <bootcpu_entry>:
void bootcpu_entry(int mhartid) {
    80202030:	fd010113          	addi	sp,sp,-48
    80202034:	02113423          	sd	ra,40(sp)
    80202038:	02813023          	sd	s0,32(sp)
    8020203c:	00913c23          	sd	s1,24(sp)
    80202040:	03010413          	addi	s0,sp,48
    80202044:	01213823          	sd	s2,16(sp)
    80202048:	01313423          	sd	s3,8(sp)
    8020204c:	00050493          	mv	s1,a0
    printf("\n\n=====\nHello World!\n=====\n\n");
    80202050:	00004517          	auipc	a0,0x4
    80202054:	8f050513          	addi	a0,a0,-1808 # 80205940 <e_text+0x940>
    80202058:	00001097          	auipc	ra,0x1
    8020205c:	b2c080e7          	jalr	-1236(ra) # 80202b84 <printf>
    printf("Boot stack: %p\nclean bss: %p - %p\n", boot_stack, s_bss, e_bss);
    80202060:	0001d697          	auipc	a3,0x1d
    80202064:	fa068693          	addi	a3,a3,-96 # 8021f000 <e_bss>
    80202068:	00007617          	auipc	a2,0x7
    8020206c:	f9860613          	addi	a2,a2,-104 # 80209000 <uart_tx_lock>
    80202070:	00006597          	auipc	a1,0x6
    80202074:	f9058593          	addi	a1,a1,-112 # 80208000 <boot_stack>
    80202078:	00004517          	auipc	a0,0x4
    8020207c:	8e850513          	addi	a0,a0,-1816 # 80205960 <e_text+0x960>
    80202080:	00001097          	auipc	ra,0x1
    80202084:	b04080e7          	jalr	-1276(ra) # 80202b84 <printf>
    memset(s_bss, 0, e_bss - s_bss);
    80202088:	00007517          	auipc	a0,0x7
    8020208c:	f7850513          	addi	a0,a0,-136 # 80209000 <uart_tx_lock>
    80202090:	0001d617          	auipc	a2,0x1d
    80202094:	f7060613          	addi	a2,a2,-144 # 8021f000 <e_bss>
    80202098:	40a6063b          	subw	a2,a2,a0
    8020209c:	00000593          	li	a1,0
    802020a0:	00002097          	auipc	ra,0x2
    802020a4:	200080e7          	jalr	512(ra) # 802042a0 <memset>
    printf("Boot m_hartid %d\n", mhartid);
    802020a8:	00048593          	mv	a1,s1
    802020ac:	00004517          	auipc	a0,0x4
    802020b0:	8dc50513          	addi	a0,a0,-1828 # 80205988 <e_text+0x988>
    802020b4:	00001097          	auipc	ra,0x1
    802020b8:	ad0080e7          	jalr	-1328(ra) # 80202b84 <printf>
    asm volatile("mv tp, %0" : : "r"(x));
    802020bc:	00000793          	li	a5,0
    802020c0:	00078213          	mv	tp,a5
    mycpu()->cpuid    = 0;
    802020c4:	00002097          	auipc	ra,0x2
    802020c8:	028080e7          	jalr	40(ra) # 802040ec <mycpu>
    802020cc:	08052c23          	sw	zero,152(a0)
    mycpu()->mhart_id = mhartid;
    802020d0:	00002097          	auipc	ra,0x2
    802020d4:	01c080e7          	jalr	28(ra) # 802040ec <mycpu>
    802020d8:	00952023          	sw	s1,0(a0)
    asm volatile("mv %0, tp" : "=r"(x));
    802020dc:	00020913          	mv	s2,tp
    802020e0:	0009091b          	sext.w	s2,s2
    struct proc *p = curr_proc();
    802020e4:	00000097          	auipc	ra,0x0
    802020e8:	c1c080e7          	jalr	-996(ra) # 80201d00 <curr_proc>
    return p ? p->pid : -1;
    802020ec:	08050063          	beqz	a0,8020216c <bootcpu_entry+0x13c>
    802020f0:	02452983          	lw	s3,36(a0)
    infof("basic smp inited, thread_id available now, we are cpu %d: %p", mhartid, mycpu());
    802020f4:	00002097          	auipc	ra,0x2
    802020f8:	ff8080e7          	jalr	-8(ra) # 802040ec <mycpu>
    802020fc:	00050893          	mv	a7,a0
    80202100:	00048813          	mv	a6,s1
    80202104:	00004797          	auipc	a5,0x4
    80202108:	15478793          	addi	a5,a5,340 # 80206258 <__func__.2>
    8020210c:	00098713          	mv	a4,s3
    80202110:	00090693          	mv	a3,s2
    80202114:	00003617          	auipc	a2,0x3
    80202118:	39c60613          	addi	a2,a2,924 # 802054b0 <e_text+0x4b0>
    8020211c:	02200593          	li	a1,34
    80202120:	00004517          	auipc	a0,0x4
    80202124:	88050513          	addi	a0,a0,-1920 # 802059a0 <e_text+0x9a0>
    80202128:	00001097          	auipc	ra,0x1
    8020212c:	a5c080e7          	jalr	-1444(ra) # 80202b84 <printf>
    printf("Jump to percpu kernel stack\n");
    80202130:	00004517          	auipc	a0,0x4
    80202134:	8c850513          	addi	a0,a0,-1848 # 802059f8 <e_text+0x9f8>
    80202138:	00001097          	auipc	ra,0x1
    8020213c:	a4c080e7          	jalr	-1460(ra) # 80202b84 <printf>
    80202140:	00020793          	mv	a5,tp
    asm volatile("mv a1, %0" ::"r"(fn));
    80202144:	00000717          	auipc	a4,0x0
    80202148:	c0470713          	addi	a4,a4,-1020 # 80201d48 <bootcpu_init>
    8020214c:	00070593          	mv	a1,a4
    uint64 sp = (uint64)&percpu_kstack[cpuid()];
    80202150:	0007879b          	sext.w	a5,a5
    80202154:	00009717          	auipc	a4,0x9
    80202158:	eac70713          	addi	a4,a4,-340 # 8020b000 <percpu_kstack>
    8020215c:	00e79793          	slli	a5,a5,0xe
    80202160:	00e787b3          	add	a5,a5,a4
    asm volatile("mv sp, %0" ::"r"(sp));
    80202164:	00078113          	mv	sp,a5
    asm volatile("jr a1");
    80202168:	00058067          	jr	a1
    8020216c:	fff00993          	li	s3,-1
    80202170:	f85ff06f          	j	802020f4 <bootcpu_entry+0xc4>

0000000080202174 <secondarycpu_entry>:
__noreturn void secondarycpu_entry(int hartid, int mycpuid) {
    80202174:	fe010113          	addi	sp,sp,-32
    80202178:	00813823          	sd	s0,16(sp)
    8020217c:	00913423          	sd	s1,8(sp)
    80202180:	01213023          	sd	s2,0(sp)
    80202184:	00113c23          	sd	ra,24(sp)
    80202188:	02010413          	addi	s0,sp,32
    printf("cpu %d (halt %d) booting. Relocating\n", mycpuid, hartid);
    8020218c:	00050613          	mv	a2,a0
__noreturn void secondarycpu_entry(int hartid, int mycpuid) {
    80202190:	00050913          	mv	s2,a0
    printf("cpu %d (halt %d) booting. Relocating\n", mycpuid, hartid);
    80202194:	00004517          	auipc	a0,0x4
    80202198:	88450513          	addi	a0,a0,-1916 # 80205a18 <e_text+0xa18>
__noreturn void secondarycpu_entry(int hartid, int mycpuid) {
    8020219c:	00058493          	mv	s1,a1
    printf("cpu %d (halt %d) booting. Relocating\n", mycpuid, hartid);
    802021a0:	00001097          	auipc	ra,0x1
    802021a4:	9e4080e7          	jalr	-1564(ra) # 80202b84 <printf>
    asm volatile("mv tp, %0" : : "r"(x));
    802021a8:	00048213          	mv	tp,s1
    getcpu(mycpuid)->mhart_id = hartid;
    802021ac:	00048513          	mv	a0,s1
    802021b0:	00002097          	auipc	ra,0x2
    802021b4:	04c080e7          	jalr	76(ra) # 802041fc <getcpu>
    802021b8:	01252023          	sw	s2,0(a0)
    getcpu(mycpuid)->cpuid    = mycpuid;
    802021bc:	00048513          	mv	a0,s1
    802021c0:	00002097          	auipc	ra,0x2
    802021c4:	03c080e7          	jalr	60(ra) # 802041fc <getcpu>
    802021c8:	08952c23          	sw	s1,152(a0)
    asm volatile("mv %0, tp" : "=r"(x));
    802021cc:	00020793          	mv	a5,tp
    asm volatile("mv a1, %0\n" ::"r"(fn));
    802021d0:	00000717          	auipc	a4,0x0
    802021d4:	d9070713          	addi	a4,a4,-624 # 80201f60 <secondarycpu_init>
    802021d8:	00070593          	mv	a1,a4
    uint64 sp = (uint64)&percpu_kstack[cpuid()];
    802021dc:	0007879b          	sext.w	a5,a5
    802021e0:	00009717          	auipc	a4,0x9
    802021e4:	e2070713          	addi	a4,a4,-480 # 8020b000 <percpu_kstack>
    802021e8:	00e79793          	slli	a5,a5,0xe
    802021ec:	00e787b3          	add	a5,a5,a4
    asm volatile("mv sp, %0\n" ::"r"(sp));
    802021f0:	00078113          	mv	sp,a5
    asm volatile("jr a1");
    802021f4:	00058067          	jr	a1

00000000802021f8 <worker>:
#define CNT_PER_THR 10000
#define SLEEP_TIME 500

volatile uint64 count = 0;

void worker(uint64 id) {
    802021f8:	fa010113          	addi	sp,sp,-96
    802021fc:	04113c23          	sd	ra,88(sp)
    80202200:	04813823          	sd	s0,80(sp)
    80202204:	04913423          	sd	s1,72(sp)
    80202208:	06010413          	addi	s0,sp,96
    8020220c:	03413823          	sd	s4,48(sp)
    80202210:	05213023          	sd	s2,64(sp)
    80202214:	03313c23          	sd	s3,56(sp)
    80202218:	03513423          	sd	s5,40(sp)
    8020221c:	03613023          	sd	s6,32(sp)
    80202220:	01713c23          	sd	s7,24(sp)
    80202224:	01813823          	sd	s8,16(sp)
    80202228:	01913423          	sd	s9,8(sp)
    push_off();
    8020222c:	fffff097          	auipc	ra,0xfffff
    80202230:	738080e7          	jalr	1848(ra) # 80201964 <push_off>
    struct cpu* c = mycpu();
    80202234:	00002097          	auipc	ra,0x2
    80202238:	eb8080e7          	jalr	-328(ra) # 802040ec <mycpu>
    struct proc* p = c->proc;
    8020223c:	00853483          	ld	s1,8(a0)
    pop_off();
    80202240:	fffff097          	auipc	ra,0xfffff
    80202244:	798080e7          	jalr	1944(ra) # 802019d8 <pop_off>
    int pid = curr_proc()->pid;
    80202248:	0244aa03          	lw	s4,36(s1)
    8020224c:	00020493          	mv	s1,tp
    push_off();
    80202250:	fffff097          	auipc	ra,0xfffff
    80202254:	714080e7          	jalr	1812(ra) # 80201964 <push_off>
    struct cpu* c = mycpu();
    80202258:	00002097          	auipc	ra,0x2
    8020225c:	e94080e7          	jalr	-364(ra) # 802040ec <mycpu>
    struct proc* p = c->proc;
    80202260:	00853903          	ld	s2,8(a0)
    return r_tp();
    80202264:	0004849b          	sext.w	s1,s1
    pop_off();
    80202268:	fffff097          	auipc	ra,0xfffff
    8020226c:	770080e7          	jalr	1904(ra) # 802019d8 <pop_off>
    80202270:	1c090e63          	beqz	s2,8020244c <worker+0x254>
    80202274:	02492703          	lw	a4,36(s2)
    warnf("thread %d: starting", pid);
    80202278:	00048693          	mv	a3,s1
    8020227c:	000a0813          	mv	a6,s4
    80202280:	00004797          	auipc	a5,0x4
    80202284:	08078793          	addi	a5,a5,128 # 80206300 <__func__.1>
    80202288:	00003617          	auipc	a2,0x3
    8020228c:	7b860613          	addi	a2,a2,1976 # 80205a40 <e_text+0xa40>
    80202290:	05d00593          	li	a1,93
    80202294:	00003517          	auipc	a0,0x3
    80202298:	7b450513          	addi	a0,a0,1972 # 80205a48 <e_text+0xa48>
    8020229c:	00002937          	lui	s2,0x2
    802022a0:	00001097          	auipc	ra,0x1
    802022a4:	8e4080e7          	jalr	-1820(ra) # 80202b84 <printf>
    802022a8:	71090913          	addi	s2,s2,1808 # 2710 <_entry-0x801fd8f0>
    802022ac:	0001c497          	auipc	s1,0x1c
    802022b0:	0e448493          	addi	s1,s1,228 # 8021e390 <count>
    for (int i = 0; i < CNT_PER_THR; i++) {
        count++;
        if (count % 1000 == 0) {
    802022b4:	3e800993          	li	s3,1000
            if (!intr_get())
                panic("interrupt should be on when executing process");

            infof("thread %d: count %d, sleeping", pid, count);
    802022b8:	00004b97          	auipc	s7,0x4
    802022bc:	048b8b93          	addi	s7,s7,72 # 80206300 <__func__.1>
    802022c0:	00003b17          	auipc	s6,0x3
    802022c4:	1f0b0b13          	addi	s6,s6,496 # 802054b0 <e_text+0x4b0>
    802022c8:	00004a97          	auipc	s5,0x4
    802022cc:	810a8a93          	addi	s5,s5,-2032 # 80205ad8 <e_text+0xad8>
        count++;
    802022d0:	0004b783          	ld	a5,0(s1)
    802022d4:	00178793          	addi	a5,a5,1
    802022d8:	00f4b023          	sd	a5,0(s1)
        if (count % 1000 == 0) {
    802022dc:	0004b783          	ld	a5,0(s1)
    802022e0:	0337f7b3          	remu	a5,a5,s3
    802022e4:	06079663          	bnez	a5,80202350 <worker+0x158>
    asm volatile("csrr %0, sstatus" : "=r"(x));
    802022e8:	100027f3          	csrr	a5,sstatus
    return (x & SSTATUS_SIE) != 0;
    802022ec:	0027f793          	andi	a5,a5,2
            if (!intr_get())
    802022f0:	10078263          	beqz	a5,802023f4 <worker+0x1fc>
    asm volatile("mv %0, tp" : "=r"(x));
    802022f4:	00020c13          	mv	s8,tp
    push_off();
    802022f8:	fffff097          	auipc	ra,0xfffff
    802022fc:	66c080e7          	jalr	1644(ra) # 80201964 <push_off>
    struct cpu* c = mycpu();
    80202300:	00002097          	auipc	ra,0x2
    80202304:	dec080e7          	jalr	-532(ra) # 802040ec <mycpu>
    struct proc* p = c->proc;
    80202308:	00853c83          	ld	s9,8(a0)
    return r_tp();
    8020230c:	000c0c1b          	sext.w	s8,s8
    pop_off();
    80202310:	fffff097          	auipc	ra,0xfffff
    80202314:	6c8080e7          	jalr	1736(ra) # 802019d8 <pop_off>
    80202318:	0c0c8a63          	beqz	s9,802023ec <worker+0x1f4>
    8020231c:	024ca703          	lw	a4,36(s9)
            infof("thread %d: count %d, sleeping", pid, count);
    80202320:	0004b883          	ld	a7,0(s1)
    80202324:	000a8513          	mv	a0,s5
    80202328:	000a0813          	mv	a6,s4
    8020232c:	000b8793          	mv	a5,s7
    80202330:	000c0693          	mv	a3,s8
    80202334:	000b0613          	mv	a2,s6
    80202338:	02200593          	li	a1,34
    8020233c:	00001097          	auipc	ra,0x1
    80202340:	848080e7          	jalr	-1976(ra) # 80202b84 <printf>
            sleepms(SLEEP_TIME);
    80202344:	1f400513          	li	a0,500
    80202348:	00002097          	auipc	ra,0x2
    8020234c:	2b8080e7          	jalr	696(ra) # 80204600 <sleepms>
    for (int i = 0; i < CNT_PER_THR; i++) {
    80202350:	fff9091b          	addiw	s2,s2,-1
    80202354:	f6091ee3          	bnez	s2,802022d0 <worker+0xd8>
    80202358:	00020493          	mv	s1,tp
    push_off();
    8020235c:	fffff097          	auipc	ra,0xfffff
    80202360:	608080e7          	jalr	1544(ra) # 80201964 <push_off>
    struct cpu* c = mycpu();
    80202364:	00002097          	auipc	ra,0x2
    80202368:	d88080e7          	jalr	-632(ra) # 802040ec <mycpu>
    struct proc* p = c->proc;
    8020236c:	00853903          	ld	s2,8(a0)
    return r_tp();
    80202370:	0004849b          	sext.w	s1,s1
    pop_off();
    80202374:	fffff097          	auipc	ra,0xfffff
    80202378:	664080e7          	jalr	1636(ra) # 802019d8 <pop_off>
    8020237c:	0c090c63          	beqz	s2,80202454 <worker+0x25c>
    80202380:	02492703          	lw	a4,36(s2)
        }
    }
    warnf("thread %d: exiting", pid);
    80202384:	000a0813          	mv	a6,s4
    80202388:	00048693          	mv	a3,s1
    8020238c:	00003517          	auipc	a0,0x3
    80202390:	78450513          	addi	a0,a0,1924 # 80205b10 <e_text+0xb10>
    80202394:	00004797          	auipc	a5,0x4
    80202398:	f6c78793          	addi	a5,a5,-148 # 80206300 <__func__.1>
    8020239c:	00003617          	auipc	a2,0x3
    802023a0:	6a460613          	addi	a2,a2,1700 # 80205a40 <e_text+0xa40>
    802023a4:	05d00593          	li	a1,93
    802023a8:	00000097          	auipc	ra,0x0
    802023ac:	7dc080e7          	jalr	2012(ra) # 80202b84 <printf>
    exit(pid + 20);
}
    802023b0:	05013403          	ld	s0,80(sp)
    802023b4:	05813083          	ld	ra,88(sp)
    802023b8:	04813483          	ld	s1,72(sp)
    802023bc:	04013903          	ld	s2,64(sp)
    802023c0:	03813983          	ld	s3,56(sp)
    802023c4:	02813a83          	ld	s5,40(sp)
    802023c8:	02013b03          	ld	s6,32(sp)
    802023cc:	01813b83          	ld	s7,24(sp)
    802023d0:	01013c03          	ld	s8,16(sp)
    802023d4:	00813c83          	ld	s9,8(sp)
    exit(pid + 20);
    802023d8:	014a051b          	addiw	a0,s4,20
}
    802023dc:	03013a03          	ld	s4,48(sp)
    802023e0:	06010113          	addi	sp,sp,96
    exit(pid + 20);
    802023e4:	00001317          	auipc	t1,0x1
    802023e8:	0b030067          	jr	176(t1) # 80203494 <exit>
    802023ec:	fff00713          	li	a4,-1
    802023f0:	f31ff06f          	j	80202320 <worker+0x128>
    802023f4:	00020493          	mv	s1,tp
    push_off();
    802023f8:	fffff097          	auipc	ra,0xfffff
    802023fc:	56c080e7          	jalr	1388(ra) # 80201964 <push_off>
    struct cpu* c = mycpu();
    80202400:	00002097          	auipc	ra,0x2
    80202404:	cec080e7          	jalr	-788(ra) # 802040ec <mycpu>
    struct proc* p = c->proc;
    80202408:	00853903          	ld	s2,8(a0)
    return r_tp();
    8020240c:	0004849b          	sext.w	s1,s1
    pop_off();
    80202410:	fffff097          	auipc	ra,0xfffff
    80202414:	5c8080e7          	jalr	1480(ra) # 802019d8 <pop_off>
    80202418:	04090263          	beqz	s2,8020245c <worker+0x264>
    8020241c:	02492703          	lw	a4,36(s2)
                panic("interrupt should be on when executing process");
    80202420:	01100813          	li	a6,17
    80202424:	00003797          	auipc	a5,0x3
    80202428:	65478793          	addi	a5,a5,1620 # 80205a78 <e_text+0xa78>
    8020242c:	00048693          	mv	a3,s1
    80202430:	00003617          	auipc	a2,0x3
    80202434:	bf860613          	addi	a2,a2,-1032 # 80205028 <e_text+0x28>
    80202438:	01f00593          	li	a1,31
    8020243c:	00003517          	auipc	a0,0x3
    80202440:	64c50513          	addi	a0,a0,1612 # 80205a88 <e_text+0xa88>
    80202444:	00000097          	auipc	ra,0x0
    80202448:	440080e7          	jalr	1088(ra) # 80202884 <__panic>
    8020244c:	fff00713          	li	a4,-1
    80202450:	e29ff06f          	j	80202278 <worker+0x80>
    80202454:	fff00713          	li	a4,-1
    80202458:	f2dff06f          	j	80202384 <worker+0x18c>
    8020245c:	fff00713          	li	a4,-1
    80202460:	fc1ff06f          	j	80202420 <worker+0x228>

0000000080202464 <init>:


void init(uint64) {
    80202464:	f7010113          	addi	sp,sp,-144
    80202468:	08813023          	sd	s0,128(sp)
    8020246c:	08113423          	sd	ra,136(sp)
    80202470:	06913c23          	sd	s1,120(sp)
    80202474:	07213823          	sd	s2,112(sp)
    80202478:	07313423          	sd	s3,104(sp)
    8020247c:	07413023          	sd	s4,96(sp)
    80202480:	05513c23          	sd	s5,88(sp)
    80202484:	05613823          	sd	s6,80(sp)
    80202488:	05713423          	sd	s7,72(sp)
    8020248c:	05813023          	sd	s8,64(sp)
    80202490:	09010413          	addi	s0,sp,144
    80202494:	00020493          	mv	s1,tp
    push_off();
    80202498:	fffff097          	auipc	ra,0xfffff
    8020249c:	4cc080e7          	jalr	1228(ra) # 80201964 <push_off>
    struct cpu* c = mycpu();
    802024a0:	00002097          	auipc	ra,0x2
    802024a4:	c4c080e7          	jalr	-948(ra) # 802040ec <mycpu>
    struct proc* p = c->proc;
    802024a8:	00853903          	ld	s2,8(a0)
    return r_tp();
    802024ac:	0004849b          	sext.w	s1,s1
    pop_off();
    802024b0:	fffff097          	auipc	ra,0xfffff
    802024b4:	528080e7          	jalr	1320(ra) # 802019d8 <pop_off>
    802024b8:	1e090a63          	beqz	s2,802026ac <init+0x248>
    802024bc:	02492703          	lw	a4,36(s2)
    infof("kthread: init starts!");
    802024c0:	00048693          	mv	a3,s1
    802024c4:	00004797          	auipc	a5,0x4
    802024c8:	e3478793          	addi	a5,a5,-460 # 802062f8 <__func__.0>
    802024cc:	00003617          	auipc	a2,0x3
    802024d0:	fe460613          	addi	a2,a2,-28 # 802054b0 <e_text+0x4b0>
    802024d4:	02200593          	li	a1,34
    802024d8:	00003517          	auipc	a0,0x3
    802024dc:	66850513          	addi	a0,a0,1640 # 80205b40 <e_text+0xb40>
    802024e0:	f9040913          	addi	s2,s0,-112
    802024e4:	00000097          	auipc	ra,0x0
    802024e8:	6a0080e7          	jalr	1696(ra) # 80202b84 <printf>
    802024ec:	00090993          	mv	s3,s2
    802024f0:	00000493          	li	s1,0
    int pids[NTHREAD];
    for (int i = 0; i < NTHREAD; i++) {
        pids[i]        = create_kthread(worker, i);
    802024f4:	00000a97          	auipc	s5,0x0
    802024f8:	d04a8a93          	addi	s5,s5,-764 # 802021f8 <worker>
    for (int i = 0; i < NTHREAD; i++) {
    802024fc:	00800a13          	li	s4,8
        pids[i]        = create_kthread(worker, i);
    80202500:	00048593          	mv	a1,s1
    80202504:	000a8513          	mv	a0,s5
    80202508:	00001097          	auipc	ra,0x1
    8020250c:	b0c080e7          	jalr	-1268(ra) # 80203014 <create_kthread>
    80202510:	00a9a023          	sw	a0,0(s3)
    for (int i = 0; i < NTHREAD; i++) {
    80202514:	00148493          	addi	s1,s1,1
    80202518:	00498993          	addi	s3,s3,4
    8020251c:	ff4492e3          	bne	s1,s4,80202500 <init+0x9c>
    80202520:	02090c13          	addi	s8,s2,32
    }
    int retcode;
    for (int i = 0; i < NTHREAD; i++) {
        int pid = wait(pids[i], &retcode);
        infof("thread %d exited with code %d, expected %d", pid, retcode, pid + 20);
    80202524:	00004b97          	auipc	s7,0x4
    80202528:	dd4b8b93          	addi	s7,s7,-556 # 802062f8 <__func__.0>
    8020252c:	00003b17          	auipc	s6,0x3
    80202530:	f84b0b13          	addi	s6,s6,-124 # 802054b0 <e_text+0x4b0>
    80202534:	00003a97          	auipc	s5,0x3
    80202538:	63ca8a93          	addi	s5,s5,1596 # 80205b70 <e_text+0xb70>
        int pid = wait(pids[i], &retcode);
    8020253c:	00092503          	lw	a0,0(s2)
    80202540:	f8c40593          	addi	a1,s0,-116
    80202544:	00001097          	auipc	ra,0x1
    80202548:	ce4080e7          	jalr	-796(ra) # 80203228 <wait>
    8020254c:	00050493          	mv	s1,a0
    80202550:	00020993          	mv	s3,tp
    push_off();
    80202554:	fffff097          	auipc	ra,0xfffff
    80202558:	410080e7          	jalr	1040(ra) # 80201964 <push_off>
    struct cpu* c = mycpu();
    8020255c:	00002097          	auipc	ra,0x2
    80202560:	b90080e7          	jalr	-1136(ra) # 802040ec <mycpu>
    struct proc* p = c->proc;
    80202564:	00853a03          	ld	s4,8(a0)
    return r_tp();
    80202568:	0009899b          	sext.w	s3,s3
    pop_off();
    8020256c:	fffff097          	auipc	ra,0xfffff
    80202570:	46c080e7          	jalr	1132(ra) # 802019d8 <pop_off>
    80202574:	120a0463          	beqz	s4,8020269c <init+0x238>
    80202578:	024a2703          	lw	a4,36(s4)
        infof("thread %d exited with code %d, expected %d", pid, retcode, pid + 20);
    8020257c:	f8c42883          	lw	a7,-116(s0)
    80202580:	0144879b          	addiw	a5,s1,20
    80202584:	00f13023          	sd	a5,0(sp)
    80202588:	00048813          	mv	a6,s1
    8020258c:	000b8793          	mv	a5,s7
    80202590:	00098693          	mv	a3,s3
    80202594:	000b0613          	mv	a2,s6
    80202598:	02200593          	li	a1,34
    8020259c:	000a8513          	mv	a0,s5
    for (int i = 0; i < NTHREAD; i++) {
    802025a0:	00490913          	addi	s2,s2,4
        infof("thread %d exited with code %d, expected %d", pid, retcode, pid + 20);
    802025a4:	00000097          	auipc	ra,0x0
    802025a8:	5e0080e7          	jalr	1504(ra) # 80202b84 <printf>
    for (int i = 0; i < NTHREAD; i++) {
    802025ac:	f98918e3          	bne	s2,s8,8020253c <init+0xd8>
    802025b0:	00020493          	mv	s1,tp
    push_off();
    802025b4:	fffff097          	auipc	ra,0xfffff
    802025b8:	3b0080e7          	jalr	944(ra) # 80201964 <push_off>
    struct cpu* c = mycpu();
    802025bc:	00002097          	auipc	ra,0x2
    802025c0:	b30080e7          	jalr	-1232(ra) # 802040ec <mycpu>
    struct proc* p = c->proc;
    802025c4:	00853903          	ld	s2,8(a0)
    return r_tp();
    802025c8:	0004849b          	sext.w	s1,s1
    pop_off();
    802025cc:	fffff097          	auipc	ra,0xfffff
    802025d0:	40c080e7          	jalr	1036(ra) # 802019d8 <pop_off>
    802025d4:	0c090863          	beqz	s2,802026a4 <init+0x240>
    802025d8:	02492703          	lw	a4,36(s2)
    }
    infof("all threads exited, count %d\n", count);
    802025dc:	0001c817          	auipc	a6,0x1c
    802025e0:	db483803          	ld	a6,-588(a6) # 8021e390 <count>
    802025e4:	00004797          	auipc	a5,0x4
    802025e8:	d1478793          	addi	a5,a5,-748 # 802062f8 <__func__.0>
    802025ec:	00048693          	mv	a3,s1
    802025f0:	00003617          	auipc	a2,0x3
    802025f4:	ec060613          	addi	a2,a2,-320 # 802054b0 <e_text+0x4b0>
    802025f8:	02200593          	li	a1,34
    802025fc:	00003517          	auipc	a0,0x3
    80202600:	5bc50513          	addi	a0,a0,1468 # 80205bb8 <e_text+0xbb8>
    80202604:	00000097          	auipc	ra,0x0
    80202608:	580080e7          	jalr	1408(ra) # 80202b84 <printf>
    8020260c:	00020493          	mv	s1,tp
    push_off();
    80202610:	fffff097          	auipc	ra,0xfffff
    80202614:	354080e7          	jalr	852(ra) # 80201964 <push_off>
    struct cpu* c = mycpu();
    80202618:	00002097          	auipc	ra,0x2
    8020261c:	ad4080e7          	jalr	-1324(ra) # 802040ec <mycpu>
    struct proc* p = c->proc;
    80202620:	00853903          	ld	s2,8(a0)
    return r_tp();
    80202624:	0004849b          	sext.w	s1,s1
    pop_off();
    80202628:	fffff097          	auipc	ra,0xfffff
    8020262c:	3b0080e7          	jalr	944(ra) # 802019d8 <pop_off>
    80202630:	08090263          	beqz	s2,802026b4 <init+0x250>
    80202634:	02492703          	lw	a4,36(s2)
    infof("init ends!");
    80202638:	00048693          	mv	a3,s1
    8020263c:	00004797          	auipc	a5,0x4
    80202640:	cbc78793          	addi	a5,a5,-836 # 802062f8 <__func__.0>
    80202644:	00003617          	auipc	a2,0x3
    80202648:	e6c60613          	addi	a2,a2,-404 # 802054b0 <e_text+0x4b0>
    8020264c:	02200593          	li	a1,34
    80202650:	00003517          	auipc	a0,0x3
    80202654:	5a050513          	addi	a0,a0,1440 # 80205bf0 <e_text+0xbf0>
    80202658:	00000097          	auipc	ra,0x0
    8020265c:	52c080e7          	jalr	1324(ra) # 80202b84 <printf>
    exit(0);
    80202660:	00000513          	li	a0,0
    80202664:	00001097          	auipc	ra,0x1
    80202668:	e30080e7          	jalr	-464(ra) # 80203494 <exit>
}
    8020266c:	08813083          	ld	ra,136(sp)
    80202670:	08013403          	ld	s0,128(sp)
    80202674:	07813483          	ld	s1,120(sp)
    80202678:	07013903          	ld	s2,112(sp)
    8020267c:	06813983          	ld	s3,104(sp)
    80202680:	06013a03          	ld	s4,96(sp)
    80202684:	05813a83          	ld	s5,88(sp)
    80202688:	05013b03          	ld	s6,80(sp)
    8020268c:	04813b83          	ld	s7,72(sp)
    80202690:	04013c03          	ld	s8,64(sp)
    80202694:	09010113          	addi	sp,sp,144
    80202698:	00008067          	ret
    8020269c:	fff00713          	li	a4,-1
    802026a0:	eddff06f          	j	8020257c <init+0x118>
    802026a4:	fff00713          	li	a4,-1
    802026a8:	f35ff06f          	j	802025dc <init+0x178>
    802026ac:	fff00713          	li	a4,-1
    802026b0:	e11ff06f          	j	802024c0 <init+0x5c>
    802026b4:	fff00713          	li	a4,-1
    802026b8:	f81ff06f          	j	80202638 <init+0x1d4>

00000000802026bc <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//
// see docs: https://github.com/riscv/riscv-plic-spec/blob/master/riscv-plic.adoc

void plicinit(void)
{
    802026bc:	ff010113          	addi	sp,sp,-16
    802026c0:	00813423          	sd	s0,8(sp)
    802026c4:	01010413          	addi	s0,sp,16
	// Interrupt source: UART0 - 10

	*(uint32 *)(KERNEL_PLIC_BASE + UART0_IRQ * 4) = 1;

	//   *(uint32*)(KERNEL_PLIC_BASE + VIRTIO0_IRQ*4) = 1;
}
    802026c8:	00813403          	ld	s0,8(sp)
	*(uint32 *)(KERNEL_PLIC_BASE + UART0_IRQ * 4) = 1;
    802026cc:	0c0007b7          	lui	a5,0xc000
    802026d0:	00100713          	li	a4,1
    802026d4:	02e7a423          	sw	a4,40(a5) # c000028 <_entry-0x741fffd8>
}
    802026d8:	01010113          	addi	sp,sp,16
    802026dc:	00008067          	ret

00000000802026e0 <plicinithart>:

void plicinithart(void)
{
    802026e0:	ff010113          	addi	sp,sp,-16
    802026e4:	00813023          	sd	s0,0(sp)
    802026e8:	00113423          	sd	ra,8(sp)
    802026ec:	01010413          	addi	s0,sp,16
	int hart = mycpu()->mhart_id;
    802026f0:	00002097          	auipc	ra,0x2
    802026f4:	9fc080e7          	jalr	-1540(ra) # 802040ec <mycpu>
    802026f8:	00052783          	lw	a5,0(a0)
	// Assumption: Each hart has two context, we use the last one referring to the S-mode context.
	//	hart 0: context 1
	//	hart 1: context 3

	// set enable bits for this hart's S-mode for the uart.
	*(uint32 *)PLIC_SENABLE(hart) = (1 << UART0_IRQ);
    802026fc:	0c002737          	lui	a4,0xc002
    80202700:	0087969b          	slliw	a3,a5,0x8
    80202704:	00d70733          	add	a4,a4,a3
    80202708:	40000693          	li	a3,1024
    8020270c:	08d72023          	sw	a3,128(a4) # c002080 <_entry-0x741fdf80>

	// set this hart's S-mode priority threshold to 0.
	*(uint32 *)PLIC_SPRIORITY(hart) = 0;
    80202710:	00d7979b          	slliw	a5,a5,0xd
    80202714:	0c201737          	lui	a4,0xc201
    80202718:	00f707b3          	add	a5,a4,a5
    8020271c:	0007a023          	sw	zero,0(a5)
    asm volatile("csrr %0, sie" : "=r"(x));
    80202720:	104027f3          	csrr	a5,sie

	w_sie(r_sie() | SIE_SEIE);	// enable External Interrupt
    80202724:	2007e793          	ori	a5,a5,512
    asm volatile("csrw sie, %0" : : "r"(x));
    80202728:	10479073          	csrw	sie,a5
}
    8020272c:	00813083          	ld	ra,8(sp)
    80202730:	00013403          	ld	s0,0(sp)
    80202734:	01010113          	addi	sp,sp,16
    80202738:	00008067          	ret

000000008020273c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int plic_claim(void)
{
    8020273c:	ff010113          	addi	sp,sp,-16
    80202740:	00813023          	sd	s0,0(sp)
    80202744:	00113423          	sd	ra,8(sp)
    80202748:	01010413          	addi	s0,sp,16
	int hart = mycpu()->mhart_id;
    8020274c:	00002097          	auipc	ra,0x2
    80202750:	9a0080e7          	jalr	-1632(ra) # 802040ec <mycpu>
	int irq = *(uint32 *)PLIC_SCLAIM(hart);
    80202754:	00052783          	lw	a5,0(a0)
	return irq;
}
    80202758:	00813083          	ld	ra,8(sp)
    8020275c:	00013403          	ld	s0,0(sp)
	int irq = *(uint32 *)PLIC_SCLAIM(hart);
    80202760:	00d7979b          	slliw	a5,a5,0xd
    80202764:	0c201737          	lui	a4,0xc201
    80202768:	00f707b3          	add	a5,a4,a5
}
    8020276c:	0047a503          	lw	a0,4(a5)
    80202770:	01010113          	addi	sp,sp,16
    80202774:	00008067          	ret

0000000080202778 <plic_complete>:

// tell the PLIC we've served this IRQ.
void plic_complete(int irq)
{
    80202778:	fe010113          	addi	sp,sp,-32
    8020277c:	00813823          	sd	s0,16(sp)
    80202780:	00913423          	sd	s1,8(sp)
    80202784:	00113c23          	sd	ra,24(sp)
    80202788:	02010413          	addi	s0,sp,32
    8020278c:	00050493          	mv	s1,a0
	int hart = mycpu()->mhart_id;
    80202790:	00002097          	auipc	ra,0x2
    80202794:	95c080e7          	jalr	-1700(ra) # 802040ec <mycpu>
	*(uint32 *)PLIC_SCLAIM(hart) = irq;
    80202798:	00052783          	lw	a5,0(a0)
}
    8020279c:	01813083          	ld	ra,24(sp)
    802027a0:	01013403          	ld	s0,16(sp)
	*(uint32 *)PLIC_SCLAIM(hart) = irq;
    802027a4:	00d7979b          	slliw	a5,a5,0xd
    802027a8:	0c201737          	lui	a4,0xc201
    802027ac:	00f707b3          	add	a5,a4,a5
    802027b0:	0097a223          	sw	s1,4(a5)
}
    802027b4:	00813483          	ld	s1,8(sp)
    802027b8:	02010113          	addi	sp,sp,32
    802027bc:	00008067          	ret

00000000802027c0 <printint.constprop.0>:
static char digits[] = "0123456789abcdef";
extern volatile int panicked;

uint64 kernelprint_lock = 0;

static void printint(int xx, int base, int sign) {
    802027c0:	fd010113          	addi	sp,sp,-48
    802027c4:	02813023          	sd	s0,32(sp)
    802027c8:	02113423          	sd	ra,40(sp)
    802027cc:	00913c23          	sd	s1,24(sp)
    802027d0:	01213823          	sd	s2,16(sp)
    802027d4:	03010413          	addi	s0,sp,48
    802027d8:	0005071b          	sext.w	a4,a0
    802027dc:	00000893          	li	a7,0
    char buf[16];
    int i;
    uint x;

    if (sign && (sign = xx < 0))
    802027e0:	08054c63          	bltz	a0,80202878 <printint.constprop.0+0xb8>
    else
        x = xx;

    i = 0;
    do {
        buf[i++] = digits[x % base];
    802027e4:	0005859b          	sext.w	a1,a1
    802027e8:	fd040693          	addi	a3,s0,-48
    i = 0;
    802027ec:	00000613          	li	a2,0
    802027f0:	00004817          	auipc	a6,0x4
    802027f4:	ad080813          	addi	a6,a6,-1328 # 802062c0 <digits>
        buf[i++] = digits[x % base];
    802027f8:	02b777bb          	remuw	a5,a4,a1
    } while ((x /= base) != 0);
    802027fc:	00168693          	addi	a3,a3,1
    80202800:	0007051b          	sext.w	a0,a4
    80202804:	00060493          	mv	s1,a2
        buf[i++] = digits[x % base];
    80202808:	0016061b          	addiw	a2,a2,1
    8020280c:	02079793          	slli	a5,a5,0x20
    80202810:	0207d793          	srli	a5,a5,0x20
    80202814:	00f807b3          	add	a5,a6,a5
    80202818:	0007c783          	lbu	a5,0(a5)
    } while ((x /= base) != 0);
    8020281c:	02b7573b          	divuw	a4,a4,a1
        buf[i++] = digits[x % base];
    80202820:	fef68fa3          	sb	a5,-1(a3)
    } while ((x /= base) != 0);
    80202824:	fcb57ae3          	bgeu	a0,a1,802027f8 <printint.constprop.0+0x38>

    if (sign)
    80202828:	00088c63          	beqz	a7,80202840 <printint.constprop.0+0x80>
        buf[i++] = '-';
    8020282c:	fe060793          	addi	a5,a2,-32
    80202830:	008787b3          	add	a5,a5,s0
    80202834:	02d00713          	li	a4,45
    80202838:	fee78823          	sb	a4,-16(a5)

    while (--i >= 0) consputc(buf[i]);
    8020283c:	00060493          	mv	s1,a2
    80202840:	fd040793          	addi	a5,s0,-48
    80202844:	009784b3          	add	s1,a5,s1
    80202848:	fff78913          	addi	s2,a5,-1
    8020284c:	0004c503          	lbu	a0,0(s1)
    80202850:	fff48493          	addi	s1,s1,-1
    80202854:	ffffe097          	auipc	ra,0xffffe
    80202858:	8e4080e7          	jalr	-1820(ra) # 80200138 <consputc>
    8020285c:	ff2498e3          	bne	s1,s2,8020284c <printint.constprop.0+0x8c>
}
    80202860:	02813083          	ld	ra,40(sp)
    80202864:	02013403          	ld	s0,32(sp)
    80202868:	01813483          	ld	s1,24(sp)
    8020286c:	01013903          	ld	s2,16(sp)
    80202870:	03010113          	addi	sp,sp,48
    80202874:	00008067          	ret
        x = -xx;
    80202878:	40a0073b          	negw	a4,a0
    if (sign && (sign = xx < 0))
    8020287c:	00100893          	li	a7,1
        x = -xx;
    80202880:	f65ff06f          	j	802027e4 <printint.constprop.0+0x24>

0000000080202884 <__panic>:
    va_start(ap, fmt);
    vprintf(fmt, ap);
    va_end(ap);
}

__noreturn void __panic(char *fmt, ...) {
    80202884:	fa010113          	addi	sp,sp,-96
    80202888:	00813823          	sd	s0,16(sp)
    8020288c:	00113c23          	sd	ra,24(sp)
    80202890:	02010413          	addi	s0,sp,32
    80202894:	02f43423          	sd	a5,40(s0)
    80202898:	00b43423          	sd	a1,8(s0)
    8020289c:	00c43823          	sd	a2,16(s0)
    802028a0:	00d43c23          	sd	a3,24(s0)
    802028a4:	02e43023          	sd	a4,32(s0)
    802028a8:	03043823          	sd	a6,48(s0)
    802028ac:	03143c23          	sd	a7,56(s0)
    asm volatile("csrrc %0, sstatus, %1" : "=r"(prev) : "r"(SSTATUS_SIE));
    802028b0:	00200793          	li	a5,2
    802028b4:	1007b7f3          	csrrc	a5,sstatus,a5
    va_list ap;

    intr_off();

    panicked = 1;
    802028b8:	00100793          	li	a5,1
    va_start(ap, fmt);
    802028bc:	00840593          	addi	a1,s0,8
    panicked = 1;
    802028c0:	0001c717          	auipc	a4,0x1c
    802028c4:	a8f72423          	sw	a5,-1400(a4) # 8021e348 <panicked>
    va_start(ap, fmt);
    802028c8:	feb43423          	sd	a1,-24(s0)
    vprintf(fmt, ap);
    802028cc:	00000097          	auipc	ra,0x0
    802028d0:	014080e7          	jalr	20(ra) # 802028e0 <vprintf>
    va_end(ap);

    while (1) asm volatile("nop":::"memory");
    802028d4:	00000013          	nop
    802028d8:	00000013          	nop
    802028dc:	ff9ff06f          	j	802028d4 <__panic+0x50>

00000000802028e0 <vprintf>:
static void vprintf(char *fmt, va_list ap) {
    802028e0:	f9010113          	addi	sp,sp,-112
    802028e4:	06813023          	sd	s0,96(sp)
    802028e8:	06113423          	sd	ra,104(sp)
    802028ec:	07010413          	addi	s0,sp,112
    802028f0:	04913c23          	sd	s1,88(sp)
    802028f4:	05213823          	sd	s2,80(sp)
    802028f8:	05313423          	sd	s3,72(sp)
    if (fmt == 0)
    802028fc:	20050463          	beqz	a0,80202b04 <vprintf+0x224>
    80202900:	03813023          	sd	s8,32(sp)
    80202904:	01913c23          	sd	s9,24(sp)
    80202908:	00050913          	mv	s2,a0
    8020290c:	00058c93          	mv	s9,a1
    80202910:	00200c13          	li	s8,2
    80202914:	100c3c73          	csrrc	s8,sstatus,s8
    return (prev & SSTATUS_SIE) != 0;
    80202918:	0001c997          	auipc	s3,0x1c
    8020291c:	a8098993          	addi	s3,s3,-1408 # 8021e398 <kernelprint_lock>
    80202920:	002c7c13          	andi	s8,s8,2
    while (__sync_lock_test_and_set(&kernelprint_lock, 1) != 0);
    80202924:	00100713          	li	a4,1
    80202928:	00070793          	mv	a5,a4
    8020292c:	0cf9b7af          	amoswap.d.aq	a5,a5,(s3)
    80202930:	fe079ce3          	bnez	a5,80202928 <vprintf+0x48>
    __sync_synchronize();
    80202934:	0ff0000f          	fence
    for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    80202938:	00094503          	lbu	a0,0(s2)
    8020293c:	00000493          	li	s1,0
    80202940:	0a050863          	beqz	a0,802029f0 <vprintf+0x110>
    80202944:	05413023          	sd	s4,64(sp)
    80202948:	03513c23          	sd	s5,56(sp)
    8020294c:	03613823          	sd	s6,48(sp)
    80202950:	03713423          	sd	s7,40(sp)
    80202954:	01a13823          	sd	s10,16(sp)
    80202958:	01b13423          	sd	s11,8(sp)
        if (c != '%') {
    8020295c:	02500a13          	li	s4,37
        switch (c) {
    80202960:	01500b93          	li	s7,21
    80202964:	00004b17          	auipc	s6,0x4
    80202968:	904b0b13          	addi	s6,s6,-1788 # 80206268 <__func__.2+0x10>
    8020296c:	00004a97          	auipc	s5,0x4
    80202970:	954a8a93          	addi	s5,s5,-1708 # 802062c0 <digits>
        if (c != '%') {
    80202974:	05451663          	bne	a0,s4,802029c0 <vprintf+0xe0>
        c = fmt[++i] & 0xff;
    80202978:	0014849b          	addiw	s1,s1,1
    8020297c:	009907b3          	add	a5,s2,s1
    80202980:	0007c783          	lbu	a5,0(a5)
    80202984:	00078d1b          	sext.w	s10,a5
        if (c == 0)
    80202988:	04078863          	beqz	a5,802029d8 <vprintf+0xf8>
        switch (c) {
    8020298c:	15478c63          	beq	a5,s4,80202ae4 <vprintf+0x204>
    80202990:	f9d7879b          	addiw	a5,a5,-99
    80202994:	0ff7f793          	zext.b	a5,a5
    80202998:	00fbec63          	bltu	s7,a5,802029b0 <vprintf+0xd0>
    8020299c:	00279793          	slli	a5,a5,0x2
    802029a0:	016787b3          	add	a5,a5,s6
    802029a4:	0007a783          	lw	a5,0(a5)
    802029a8:	016787b3          	add	a5,a5,s6
    802029ac:	00078067          	jr	a5
                consputc('%');
    802029b0:	02500513          	li	a0,37
    802029b4:	ffffd097          	auipc	ra,0xffffd
    802029b8:	784080e7          	jalr	1924(ra) # 80200138 <consputc>
                consputc(c);
    802029bc:	000d0513          	mv	a0,s10
    802029c0:	ffffd097          	auipc	ra,0xffffd
    802029c4:	778080e7          	jalr	1912(ra) # 80200138 <consputc>
    for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    802029c8:	0014849b          	addiw	s1,s1,1
    802029cc:	009907b3          	add	a5,s2,s1
    802029d0:	0007c503          	lbu	a0,0(a5)
    802029d4:	fa0510e3          	bnez	a0,80202974 <vprintf+0x94>
    802029d8:	04013a03          	ld	s4,64(sp)
    802029dc:	03813a83          	ld	s5,56(sp)
    802029e0:	03013b03          	ld	s6,48(sp)
    802029e4:	02813b83          	ld	s7,40(sp)
    802029e8:	01013d03          	ld	s10,16(sp)
    802029ec:	00813d83          	ld	s11,8(sp)
    __sync_synchronize();
    802029f0:	0ff0000f          	fence
    __sync_lock_release(&kernelprint_lock);
    802029f4:	0f50000f          	fence	iorw,ow
    802029f8:	0809b02f          	amoswap.d	zero,zero,(s3)
    if (intr)
    802029fc:	000c0663          	beqz	s8,80202a08 <vprintf+0x128>
    asm volatile("csrrs x0, sstatus, %0" ::"r"(SSTATUS_SIE));
    80202a00:	00200793          	li	a5,2
    80202a04:	1007a073          	csrs	sstatus,a5
}
    80202a08:	06813083          	ld	ra,104(sp)
    80202a0c:	06013403          	ld	s0,96(sp)
    80202a10:	05813483          	ld	s1,88(sp)
    80202a14:	05013903          	ld	s2,80(sp)
    80202a18:	04813983          	ld	s3,72(sp)
    80202a1c:	02013c03          	ld	s8,32(sp)
    80202a20:	01813c83          	ld	s9,24(sp)
    80202a24:	07010113          	addi	sp,sp,112
    80202a28:	00008067          	ret
                printint(va_arg(ap, int), 16, 1);
    80202a2c:	000ca503          	lw	a0,0(s9)
    80202a30:	01000593          	li	a1,16
    80202a34:	008c8c93          	addi	s9,s9,8
    80202a38:	00000097          	auipc	ra,0x0
    80202a3c:	d88080e7          	jalr	-632(ra) # 802027c0 <printint.constprop.0>
                break;
    80202a40:	f89ff06f          	j	802029c8 <vprintf+0xe8>
                if ((s = va_arg(ap, char *)) == 0)
    80202a44:	000cbd03          	ld	s10,0(s9)
    80202a48:	008c8c93          	addi	s9,s9,8
    80202a4c:	0a0d0463          	beqz	s10,80202af4 <vprintf+0x214>
                for (; *s; s++) consputc(*s);
    80202a50:	000d4503          	lbu	a0,0(s10)
    80202a54:	f6050ae3          	beqz	a0,802029c8 <vprintf+0xe8>
    80202a58:	ffffd097          	auipc	ra,0xffffd
    80202a5c:	6e0080e7          	jalr	1760(ra) # 80200138 <consputc>
    80202a60:	001d4503          	lbu	a0,1(s10)
    80202a64:	001d0d13          	addi	s10,s10,1
    80202a68:	fe0518e3          	bnez	a0,80202a58 <vprintf+0x178>
    80202a6c:	f5dff06f          	j	802029c8 <vprintf+0xe8>
    consputc('0');
    80202a70:	03000513          	li	a0,48
                printptr(va_arg(ap, uint64));
    80202a74:	000cbd83          	ld	s11,0(s9)
    consputc('0');
    80202a78:	ffffd097          	auipc	ra,0xffffd
    80202a7c:	6c0080e7          	jalr	1728(ra) # 80200138 <consputc>
    consputc('x');
    80202a80:	07800513          	li	a0,120
                printptr(va_arg(ap, uint64));
    80202a84:	008c8c93          	addi	s9,s9,8
    consputc('x');
    80202a88:	ffffd097          	auipc	ra,0xffffd
    80202a8c:	6b0080e7          	jalr	1712(ra) # 80200138 <consputc>
    80202a90:	01000d13          	li	s10,16
        consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80202a94:	03cdd793          	srli	a5,s11,0x3c
    80202a98:	00fa87b3          	add	a5,s5,a5
    80202a9c:	0007c503          	lbu	a0,0(a5)
    for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80202aa0:	fffd0d1b          	addiw	s10,s10,-1
    80202aa4:	004d9d93          	slli	s11,s11,0x4
        consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80202aa8:	ffffd097          	auipc	ra,0xffffd
    80202aac:	690080e7          	jalr	1680(ra) # 80200138 <consputc>
    for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80202ab0:	fe0d12e3          	bnez	s10,80202a94 <vprintf+0x1b4>
    80202ab4:	f15ff06f          	j	802029c8 <vprintf+0xe8>
                printint(va_arg(ap, int), 10, 1);
    80202ab8:	000ca503          	lw	a0,0(s9)
    80202abc:	00a00593          	li	a1,10
    80202ac0:	008c8c93          	addi	s9,s9,8
    80202ac4:	00000097          	auipc	ra,0x0
    80202ac8:	cfc080e7          	jalr	-772(ra) # 802027c0 <printint.constprop.0>
                break;
    80202acc:	efdff06f          	j	802029c8 <vprintf+0xe8>
                consputc(va_arg(ap, int));
    80202ad0:	000ca503          	lw	a0,0(s9)
    80202ad4:	008c8c93          	addi	s9,s9,8
    80202ad8:	ffffd097          	auipc	ra,0xffffd
    80202adc:	660080e7          	jalr	1632(ra) # 80200138 <consputc>
                break;
    80202ae0:	ee9ff06f          	j	802029c8 <vprintf+0xe8>
                consputc('%');
    80202ae4:	02500513          	li	a0,37
    80202ae8:	ffffd097          	auipc	ra,0xffffd
    80202aec:	650080e7          	jalr	1616(ra) # 80200138 <consputc>
                break;
    80202af0:	ed9ff06f          	j	802029c8 <vprintf+0xe8>
    80202af4:	02800513          	li	a0,40
                    s = "(null)";
    80202af8:	00003d17          	auipc	s10,0x3
    80202afc:	120d0d13          	addi	s10,s10,288 # 80205c18 <e_text+0xc18>
    80202b00:	f59ff06f          	j	80202a58 <vprintf+0x178>
    asm volatile("mv %0, tp" : "=r"(x));
    80202b04:	05413023          	sd	s4,64(sp)
    80202b08:	03513c23          	sd	s5,56(sp)
    80202b0c:	03613823          	sd	s6,48(sp)
    80202b10:	03713423          	sd	s7,40(sp)
    80202b14:	03813023          	sd	s8,32(sp)
    80202b18:	01913c23          	sd	s9,24(sp)
    80202b1c:	01a13823          	sd	s10,16(sp)
    80202b20:	01b13423          	sd	s11,8(sp)
    80202b24:	00020493          	mv	s1,tp
    push_off();
    80202b28:	fffff097          	auipc	ra,0xfffff
    80202b2c:	e3c080e7          	jalr	-452(ra) # 80201964 <push_off>
    struct cpu* c = mycpu();
    80202b30:	00001097          	auipc	ra,0x1
    80202b34:	5bc080e7          	jalr	1468(ra) # 802040ec <mycpu>
    struct proc* p = c->proc;
    80202b38:	00853903          	ld	s2,8(a0)
    return r_tp();
    80202b3c:	0004849b          	sext.w	s1,s1
    pop_off();
    80202b40:	fffff097          	auipc	ra,0xfffff
    80202b44:	e98080e7          	jalr	-360(ra) # 802019d8 <pop_off>
    80202b48:	02090a63          	beqz	s2,80202b7c <vprintf+0x29c>
    80202b4c:	02492703          	lw	a4,36(s2)
        panic("null fmt");
    80202b50:	03000813          	li	a6,48
    80202b54:	00003797          	auipc	a5,0x3
    80202b58:	0cc78793          	addi	a5,a5,204 # 80205c20 <e_text+0xc20>
    80202b5c:	00048693          	mv	a3,s1
    80202b60:	00002617          	auipc	a2,0x2
    80202b64:	4c860613          	addi	a2,a2,1224 # 80205028 <e_text+0x28>
    80202b68:	01f00593          	li	a1,31
    80202b6c:	00003517          	auipc	a0,0x3
    80202b70:	0c450513          	addi	a0,a0,196 # 80205c30 <e_text+0xc30>
    80202b74:	00000097          	auipc	ra,0x0
    80202b78:	d10080e7          	jalr	-752(ra) # 80202884 <__panic>
    80202b7c:	fff00713          	li	a4,-1
    80202b80:	fd1ff06f          	j	80202b50 <vprintf+0x270>

0000000080202b84 <printf>:
void printf(char *fmt, ...) {
    80202b84:	fa010113          	addi	sp,sp,-96
    80202b88:	00813823          	sd	s0,16(sp)
    80202b8c:	00113c23          	sd	ra,24(sp)
    80202b90:	02010413          	addi	s0,sp,32
    va_start(ap, fmt);
    80202b94:	00840313          	addi	t1,s0,8
void printf(char *fmt, ...) {
    80202b98:	00b43423          	sd	a1,8(s0)
    vprintf(fmt, ap);
    80202b9c:	00030593          	mv	a1,t1
void printf(char *fmt, ...) {
    80202ba0:	00c43823          	sd	a2,16(s0)
    80202ba4:	00d43c23          	sd	a3,24(s0)
    80202ba8:	02e43023          	sd	a4,32(s0)
    80202bac:	02f43423          	sd	a5,40(s0)
    80202bb0:	03043823          	sd	a6,48(s0)
    80202bb4:	03143c23          	sd	a7,56(s0)
    va_start(ap, fmt);
    80202bb8:	fe643423          	sd	t1,-24(s0)
    vprintf(fmt, ap);
    80202bbc:	00000097          	auipc	ra,0x0
    80202bc0:	d24080e7          	jalr	-732(ra) # 802028e0 <vprintf>
}
    80202bc4:	01813083          	ld	ra,24(sp)
    80202bc8:	01013403          	ld	s0,16(sp)
    80202bcc:	06010113          	addi	sp,sp,96
    80202bd0:	00008067          	ret

0000000080202bd4 <curr_proc>:
        return -1;

    // initialize process state
    p->context.ra = (uint64)first_sched_ret;
    p->context.sp = p->kstack + PGSIZE;
    p->context.s1 = (uint64)fn;
    80202bd4:	fe010113          	addi	sp,sp,-32
    80202bd8:	00113c23          	sd	ra,24(sp)
    80202bdc:	00813823          	sd	s0,16(sp)
    80202be0:	00913423          	sd	s1,8(sp)
    80202be4:	02010413          	addi	s0,sp,32
    p->context.s2 = arg;
    80202be8:	fffff097          	auipc	ra,0xfffff
    80202bec:	d7c080e7          	jalr	-644(ra) # 80201964 <push_off>
    p->state = RUNNABLE;
    80202bf0:	00001097          	auipc	ra,0x1
    80202bf4:	4fc080e7          	jalr	1276(ra) # 802040ec <mycpu>
    p->parent = init_proc;
    80202bf8:	00853483          	ld	s1,8(a0)

    80202bfc:	fffff097          	auipc	ra,0xfffff
    80202c00:	ddc080e7          	jalr	-548(ra) # 802019d8 <pop_off>
    int pid = p->pid;
    add_task(p);
    80202c04:	01813083          	ld	ra,24(sp)
    80202c08:	01013403          	ld	s0,16(sp)
    80202c0c:	00048513          	mv	a0,s1
    80202c10:	00813483          	ld	s1,8(sp)
    80202c14:	02010113          	addi	sp,sp,32
    80202c18:	00008067          	ret

0000000080202c1c <first_sched_ret>:
static void first_sched_ret(void) {
    80202c1c:	fe010113          	addi	sp,sp,-32
    80202c20:	00813823          	sd	s0,16(sp)
    80202c24:	00113c23          	sd	ra,24(sp)
    80202c28:	00913423          	sd	s1,8(sp)
    80202c2c:	01213023          	sd	s2,0(sp)
    80202c30:	02010413          	addi	s0,sp,32
    asm volatile("mv %0, s1":"=r"(fn));
    80202c34:	00048493          	mv	s1,s1
    asm volatile("mv %0, s2":"=r"(arg));
    80202c38:	00090913          	mv	s2,s2
    release(&curr_proc()->lock);
    80202c3c:	00000097          	auipc	ra,0x0
    80202c40:	f98080e7          	jalr	-104(ra) # 80202bd4 <curr_proc>
    80202c44:	fffff097          	auipc	ra,0xfffff
    80202c48:	ffc080e7          	jalr	-4(ra) # 80201c40 <release>
    asm volatile("csrrs x0, sstatus, %0" ::"r"(SSTATUS_SIE));
    80202c4c:	00200793          	li	a5,2
    80202c50:	1007a073          	csrs	sstatus,a5
    fn(arg);
    80202c54:	00090513          	mv	a0,s2
    80202c58:	000480e7          	jalr	s1
    asm volatile("mv %0, tp" : "=r"(x));
    80202c5c:	00020493          	mv	s1,tp
    return r_tp();
    80202c60:	0004849b          	sext.w	s1,s1
    struct proc *p = curr_proc();
    80202c64:	00000097          	auipc	ra,0x0
    80202c68:	f70080e7          	jalr	-144(ra) # 80202bd4 <curr_proc>
    return p ? p->pid : -1;
    80202c6c:	02050a63          	beqz	a0,80202ca0 <first_sched_ret+0x84>
    80202c70:	02452703          	lw	a4,36(a0)
    panic("first_sched_ret should never return. You should use exit to terminate kthread");
    80202c74:	04100813          	li	a6,65
    80202c78:	00003797          	auipc	a5,0x3
    80202c7c:	fe078793          	addi	a5,a5,-32 # 80205c58 <e_text+0xc58>
    80202c80:	00048693          	mv	a3,s1
    80202c84:	00002617          	auipc	a2,0x2
    80202c88:	3a460613          	addi	a2,a2,932 # 80205028 <e_text+0x28>
    80202c8c:	01f00593          	li	a1,31
    80202c90:	00003517          	auipc	a0,0x3
    80202c94:	fd850513          	addi	a0,a0,-40 # 80205c68 <e_text+0xc68>
    80202c98:	00000097          	auipc	ra,0x0
    80202c9c:	bec080e7          	jalr	-1044(ra) # 80202884 <__panic>
    80202ca0:	fff00713          	li	a4,-1
    80202ca4:	fd1ff06f          	j	80202c74 <first_sched_ret+0x58>

0000000080202ca8 <proc_init>:
void proc_init() {
    80202ca8:	fc010113          	addi	sp,sp,-64
    80202cac:	02813823          	sd	s0,48(sp)
    80202cb0:	03213023          	sd	s2,32(sp)
    80202cb4:	02113c23          	sd	ra,56(sp)
    80202cb8:	02913423          	sd	s1,40(sp)
    80202cbc:	01313c23          	sd	s3,24(sp)
    80202cc0:	01413823          	sd	s4,16(sp)
    80202cc4:	01513423          	sd	s5,8(sp)
    80202cc8:	01613023          	sd	s6,0(sp)
    80202ccc:	04010413          	addi	s0,sp,64
    assert(proc_inited == 0);
    80202cd0:	0001b797          	auipc	a5,0x1b
    80202cd4:	6d078793          	addi	a5,a5,1744 # 8021e3a0 <proc_inited.1>
    80202cd8:	0007a903          	lw	s2,0(a5)
    80202cdc:	14091e63          	bnez	s2,80202e38 <proc_init+0x190>
    proc_inited = 1;
    80202ce0:	00100713          	li	a4,1
    spinlock_init(&pid_lock, "pid");
    80202ce4:	00003597          	auipc	a1,0x3
    80202ce8:	00c58593          	addi	a1,a1,12 # 80205cf0 <e_text+0xcf0>
    80202cec:	00018517          	auipc	a0,0x18
    80202cf0:	31450513          	addi	a0,a0,788 # 8021b000 <pid_lock>
    proc_inited = 1;
    80202cf4:	00e7a023          	sw	a4,0(a5)
    spinlock_init(&pid_lock, "pid");
    80202cf8:	fffff097          	auipc	ra,0xfffff
    80202cfc:	bcc080e7          	jalr	-1076(ra) # 802018c4 <spinlock_init>
    spinlock_init(&wait_lock, "wait");
    80202d00:	00003597          	auipc	a1,0x3
    80202d04:	ff858593          	addi	a1,a1,-8 # 80205cf8 <e_text+0xcf8>
    80202d08:	00018517          	auipc	a0,0x18
    80202d0c:	31850513          	addi	a0,a0,792 # 8021b020 <wait_lock>
    80202d10:	fffff097          	auipc	ra,0xfffff
    80202d14:	bb4080e7          	jalr	-1100(ra) # 802018c4 <spinlock_init>
    allocator_init(&proc_allocator, "proc", sizeof(struct proc), NPROC);
    80202d18:	20000693          	li	a3,512
    80202d1c:	0c800613          	li	a2,200
    80202d20:	00003597          	auipc	a1,0x3
    80202d24:	fe058593          	addi	a1,a1,-32 # 80205d00 <e_text+0xd00>
    80202d28:	00018517          	auipc	a0,0x18
    80202d2c:	31850513          	addi	a0,a0,792 # 8021b040 <proc_allocator>
    80202d30:	ffffe097          	auipc	ra,0xffffe
    80202d34:	4a4080e7          	jalr	1188(ra) # 802011d4 <allocator_init>
    for (int i = 0; i < NPROC; i++) {
    80202d38:	00018997          	auipc	s3,0x18
    80202d3c:	36098993          	addi	s3,s3,864 # 8021b098 <pool>
        p = kalloc(&proc_allocator);
    80202d40:	00018a97          	auipc	s5,0x18
    80202d44:	300a8a93          	addi	s5,s5,768 # 8021b040 <proc_allocator>
        spinlock_init(&p->lock, "proc");
    80202d48:	00003a17          	auipc	s4,0x3
    80202d4c:	fb8a0a13          	addi	s4,s4,-72 # 80205d00 <e_text+0xd00>
    for (int i = 0; i < NPROC; i++) {
    80202d50:	20000b13          	li	s6,512
        p = kalloc(&proc_allocator);
    80202d54:	000a8513          	mv	a0,s5
    80202d58:	fffff097          	auipc	ra,0xfffff
    80202d5c:	864080e7          	jalr	-1948(ra) # 802015bc <kalloc>
        memset(p, 0, sizeof(*p));
    80202d60:	0c800613          	li	a2,200
    80202d64:	00000593          	li	a1,0
        p = kalloc(&proc_allocator);
    80202d68:	00050493          	mv	s1,a0
        memset(p, 0, sizeof(*p));
    80202d6c:	00001097          	auipc	ra,0x1
    80202d70:	534080e7          	jalr	1332(ra) # 802042a0 <memset>
        spinlock_init(&p->lock, "proc");
    80202d74:	000a0593          	mv	a1,s4
    80202d78:	00048513          	mv	a0,s1
    80202d7c:	fffff097          	auipc	ra,0xfffff
    80202d80:	b48080e7          	jalr	-1208(ra) # 802018c4 <spinlock_init>
        p->index = i;
    80202d84:	0524a423          	sw	s2,72(s1)
        p->state = UNUSED;
    80202d88:	0204a023          	sw	zero,32(s1)
        p->kstack = (uint64)kallocpage();
    80202d8c:	ffffe097          	auipc	ra,0xffffe
    80202d90:	390080e7          	jalr	912(ra) # 8020111c <kallocpage>
    80202d94:	04a4b823          	sd	a0,80(s1)
        assert(p->kstack);
    80202d98:	04050063          	beqz	a0,80202dd8 <proc_init+0x130>
        pool[i] = p;
    80202d9c:	0099b023          	sd	s1,0(s3)
    for (int i = 0; i < NPROC; i++) {
    80202da0:	0019091b          	addiw	s2,s2,1
    80202da4:	00898993          	addi	s3,s3,8
    80202da8:	fb6916e3          	bne	s2,s6,80202d54 <proc_init+0xac>
}
    80202dac:	03013403          	ld	s0,48(sp)
    80202db0:	03813083          	ld	ra,56(sp)
    80202db4:	02813483          	ld	s1,40(sp)
    80202db8:	02013903          	ld	s2,32(sp)
    80202dbc:	01813983          	ld	s3,24(sp)
    80202dc0:	01013a03          	ld	s4,16(sp)
    80202dc4:	00813a83          	ld	s5,8(sp)
    80202dc8:	00013b03          	ld	s6,0(sp)
    80202dcc:	04010113          	addi	sp,sp,64
    sched_init();
    80202dd0:	00001317          	auipc	t1,0x1
    80202dd4:	b5830067          	jr	-1192(t1) # 80203928 <sched_init>
    80202dd8:	00020493          	mv	s1,tp
    push_off();
    80202ddc:	fffff097          	auipc	ra,0xfffff
    80202de0:	b88080e7          	jalr	-1144(ra) # 80201964 <push_off>
    struct cpu* c = mycpu();
    80202de4:	00001097          	auipc	ra,0x1
    80202de8:	308080e7          	jalr	776(ra) # 802040ec <mycpu>
    struct proc* p = c->proc;
    80202dec:	00853903          	ld	s2,8(a0)
    return r_tp();
    80202df0:	0004849b          	sext.w	s1,s1
    pop_off();
    80202df4:	fffff097          	auipc	ra,0xfffff
    80202df8:	be4080e7          	jalr	-1052(ra) # 802019d8 <pop_off>
    80202dfc:	06090263          	beqz	s2,80202e60 <proc_init+0x1b8>
    80202e00:	02492703          	lw	a4,36(s2)
        assert(p->kstack);
    80202e04:	00003897          	auipc	a7,0x3
    80202e08:	f0488893          	addi	a7,a7,-252 # 80205d08 <e_text+0xd08>
    80202e0c:	02600813          	li	a6,38
    80202e10:	00003797          	auipc	a5,0x3
    80202e14:	e4878793          	addi	a5,a5,-440 # 80205c58 <e_text+0xc58>
    80202e18:	00048693          	mv	a3,s1
    80202e1c:	00002617          	auipc	a2,0x2
    80202e20:	20c60613          	addi	a2,a2,524 # 80205028 <e_text+0x28>
    80202e24:	01f00593          	li	a1,31
    80202e28:	00002517          	auipc	a0,0x2
    80202e2c:	20850513          	addi	a0,a0,520 # 80205030 <e_text+0x30>
    80202e30:	00000097          	auipc	ra,0x0
    80202e34:	a54080e7          	jalr	-1452(ra) # 80202884 <__panic>
    80202e38:	00020493          	mv	s1,tp
    return r_tp();
    80202e3c:	0004849b          	sext.w	s1,s1
    struct proc *p = curr_proc();
    80202e40:	00000097          	auipc	ra,0x0
    80202e44:	d94080e7          	jalr	-620(ra) # 80202bd4 <curr_proc>
    return p ? p->pid : -1;
    80202e48:	02050063          	beqz	a0,80202e68 <proc_init+0x1c0>
    80202e4c:	02452703          	lw	a4,36(a0)
    assert(proc_inited == 0);
    80202e50:	00003897          	auipc	a7,0x3
    80202e54:	e8888893          	addi	a7,a7,-376 # 80205cd8 <e_text+0xcd8>
    80202e58:	01500813          	li	a6,21
    80202e5c:	fb5ff06f          	j	80202e10 <proc_init+0x168>
    80202e60:	fff00713          	li	a4,-1
    80202e64:	fa1ff06f          	j	80202e04 <proc_init+0x15c>
    80202e68:	fff00713          	li	a4,-1
    80202e6c:	fe5ff06f          	j	80202e50 <proc_init+0x1a8>

0000000080202e70 <allocproc>:
}

// Look in the process table for an UNUSED proc.
// If found, initialize state required to run in the kernel.
// If there are no free procs, or a memory allocation fails, return 0.
struct proc *allocproc() {
    80202e70:	fd010113          	addi	sp,sp,-48
    80202e74:	02813023          	sd	s0,32(sp)
    80202e78:	01213823          	sd	s2,16(sp)
    80202e7c:	01313423          	sd	s3,8(sp)
    80202e80:	02113423          	sd	ra,40(sp)
    80202e84:	00913c23          	sd	s1,24(sp)
    80202e88:	03010413          	addi	s0,sp,48
    80202e8c:	00018917          	auipc	s2,0x18
    80202e90:	20c90913          	addi	s2,s2,524 # 8021b098 <pool>
    80202e94:	00019997          	auipc	s3,0x19
    80202e98:	20498993          	addi	s3,s3,516 # 8021c098 <task_queue>
    80202e9c:	0180006f          	j	80202eb4 <allocproc+0x44>
        p = pool[i];
        acquire(&p->lock);
        if (p->state == UNUSED) {
            goto found;
        }
        release(&p->lock);
    80202ea0:	00048513          	mv	a0,s1
    for (int i = 0; i < NPROC; i++) {
    80202ea4:	00890913          	addi	s2,s2,8
        release(&p->lock);
    80202ea8:	fffff097          	auipc	ra,0xfffff
    80202eac:	d98080e7          	jalr	-616(ra) # 80201c40 <release>
    for (int i = 0; i < NPROC; i++) {
    80202eb0:	0f390663          	beq	s2,s3,80202f9c <allocproc+0x12c>
        p = pool[i];
    80202eb4:	00093483          	ld	s1,0(s2)
        acquire(&p->lock);
    80202eb8:	00048513          	mv	a0,s1
    80202ebc:	fffff097          	auipc	ra,0xfffff
    80202ec0:	c40080e7          	jalr	-960(ra) # 80201afc <acquire>
        if (p->state == UNUSED) {
    80202ec4:	0204a783          	lw	a5,32(s1)
    80202ec8:	fc079ce3          	bnez	a5,80202ea0 <allocproc+0x30>
    }
    return 0;

found:
    // initialize a proc
    tracef("init proc %p", p);
    80202ecc:	00048593          	mv	a1,s1
    80202ed0:	00000513          	li	a0,0
    80202ed4:	00001097          	auipc	ra,0x1
    80202ed8:	678080e7          	jalr	1656(ra) # 8020454c <dummy>
    acquire(&pid_lock);
    80202edc:	00018517          	auipc	a0,0x18
    80202ee0:	12450513          	addi	a0,a0,292 # 8021b000 <pid_lock>
    80202ee4:	fffff097          	auipc	ra,0xfffff
    80202ee8:	c18080e7          	jalr	-1000(ra) # 80201afc <acquire>
    retpid = PID++;
    80202eec:	00004797          	auipc	a5,0x4
    80202ef0:	11478793          	addi	a5,a5,276 # 80207000 <PID.0>
    80202ef4:	0007a903          	lw	s2,0(a5)
    release(&pid_lock);
    80202ef8:	00018517          	auipc	a0,0x18
    80202efc:	10850513          	addi	a0,a0,264 # 8021b000 <pid_lock>
    retpid = PID++;
    80202f00:	0019071b          	addiw	a4,s2,1
    80202f04:	00e7a023          	sw	a4,0(a5)
    release(&pid_lock);
    80202f08:	fffff097          	auipc	ra,0xfffff
    80202f0c:	d38080e7          	jalr	-712(ra) # 80201c40 <release>
    p->pid        = allocpid();
    p->state      = USED;
    80202f10:	00100793          	li	a5,1
    80202f14:	02f4a023          	sw	a5,32(s1)
    p->killed     = 0;
    p->sleep_chan = NULL;
    p->parent     = NULL;
    p->exit_code  = 0;

    memset(&p->context, 0, sizeof(p->context));
    80202f18:	07000613          	li	a2,112
    80202f1c:	00000593          	li	a1,0
    p->pid        = allocpid();
    80202f20:	0324a223          	sw	s2,36(s1)
    p->killed     = 0;
    80202f24:	0204ac23          	sw	zero,56(s1)
    p->sleep_chan = NULL;
    80202f28:	0204b823          	sd	zero,48(s1)
    p->parent     = NULL;
    80202f2c:	0404b023          	sd	zero,64(s1)
    p->exit_code  = 0;
    80202f30:	0204b423          	sd	zero,40(s1)
    memset(&p->context, 0, sizeof(p->context));
    80202f34:	05848513          	addi	a0,s1,88
    80202f38:	00001097          	auipc	ra,0x1
    80202f3c:	368080e7          	jalr	872(ra) # 802042a0 <memset>
    memset((void *)p->kstack, 0, PGSIZE);
    80202f40:	0504b503          	ld	a0,80(s1)
    80202f44:	00001637          	lui	a2,0x1
    80202f48:	00000593          	li	a1,0
    80202f4c:	00001097          	auipc	ra,0x1
    80202f50:	354080e7          	jalr	852(ra) # 802042a0 <memset>

    if (!init_proc)
    80202f54:	0001b797          	auipc	a5,0x1b
    80202f58:	45478793          	addi	a5,a5,1108 # 8021e3a8 <init_proc>
    80202f5c:	0007b703          	ld	a4,0(a5)
    80202f60:	02070a63          	beqz	a4,80202f94 <allocproc+0x124>
        init_proc = p;

    assert(holding(&p->lock));
    80202f64:	00048513          	mv	a0,s1
    80202f68:	fffff097          	auipc	ra,0xfffff
    80202f6c:	9b0080e7          	jalr	-1616(ra) # 80201918 <holding>
    80202f70:	04050863          	beqz	a0,80202fc0 <allocproc+0x150>

    return p;

    // Resources clean up.
}
    80202f74:	02813083          	ld	ra,40(sp)
    80202f78:	02013403          	ld	s0,32(sp)
    80202f7c:	01013903          	ld	s2,16(sp)
    80202f80:	00813983          	ld	s3,8(sp)
    80202f84:	00048513          	mv	a0,s1
    80202f88:	01813483          	ld	s1,24(sp)
    80202f8c:	03010113          	addi	sp,sp,48
    80202f90:	00008067          	ret
        init_proc = p;
    80202f94:	0097b023          	sd	s1,0(a5)
    80202f98:	fcdff06f          	j	80202f64 <allocproc+0xf4>
}
    80202f9c:	02813083          	ld	ra,40(sp)
    80202fa0:	02013403          	ld	s0,32(sp)
    return 0;
    80202fa4:	00000493          	li	s1,0
}
    80202fa8:	01013903          	ld	s2,16(sp)
    80202fac:	00813983          	ld	s3,8(sp)
    80202fb0:	00048513          	mv	a0,s1
    80202fb4:	01813483          	ld	s1,24(sp)
    80202fb8:	03010113          	addi	sp,sp,48
    80202fbc:	00008067          	ret
    80202fc0:	00020493          	mv	s1,tp
    80202fc4:	0004849b          	sext.w	s1,s1
    struct proc *p = curr_proc();
    80202fc8:	00000097          	auipc	ra,0x0
    80202fcc:	c0c080e7          	jalr	-1012(ra) # 80202bd4 <curr_proc>
    return p ? p->pid : -1;
    80202fd0:	02050e63          	beqz	a0,8020300c <allocproc+0x19c>
    80202fd4:	02452703          	lw	a4,36(a0)
    assert(holding(&p->lock));
    80202fd8:	00003897          	auipc	a7,0x3
    80202fdc:	d4088893          	addi	a7,a7,-704 # 80205d18 <e_text+0xd18>
    80202fe0:	07700813          	li	a6,119
    80202fe4:	00003797          	auipc	a5,0x3
    80202fe8:	c7478793          	addi	a5,a5,-908 # 80205c58 <e_text+0xc58>
    80202fec:	00048693          	mv	a3,s1
    80202ff0:	00002617          	auipc	a2,0x2
    80202ff4:	03860613          	addi	a2,a2,56 # 80205028 <e_text+0x28>
    80202ff8:	01f00593          	li	a1,31
    80202ffc:	00002517          	auipc	a0,0x2
    80203000:	03450513          	addi	a0,a0,52 # 80205030 <e_text+0x30>
    80203004:	00000097          	auipc	ra,0x0
    80203008:	880080e7          	jalr	-1920(ra) # 80202884 <__panic>
    8020300c:	fff00713          	li	a4,-1
    80203010:	fc9ff06f          	j	80202fd8 <allocproc+0x168>

0000000080203014 <create_kthread>:
int create_kthread(void (*fn)(uint64), uint64 arg) {
    80203014:	fd010113          	addi	sp,sp,-48
    80203018:	02813023          	sd	s0,32(sp)
    8020301c:	01213823          	sd	s2,16(sp)
    80203020:	01313423          	sd	s3,8(sp)
    80203024:	02113423          	sd	ra,40(sp)
    80203028:	03010413          	addi	s0,sp,48
    8020302c:	00050993          	mv	s3,a0
    80203030:	00058913          	mv	s2,a1
    struct proc *p = allocproc();
    80203034:	00000097          	auipc	ra,0x0
    80203038:	e3c080e7          	jalr	-452(ra) # 80202e70 <allocproc>
    if (!p)
    8020303c:	06050e63          	beqz	a0,802030b8 <create_kthread+0xa4>
    p->context.sp = p->kstack + PGSIZE;
    80203040:	05053783          	ld	a5,80(a0)
    80203044:	00001737          	lui	a4,0x1
    80203048:	00913c23          	sd	s1,24(sp)
    8020304c:	00e787b3          	add	a5,a5,a4
    80203050:	06f53023          	sd	a5,96(a0)
    p->state = RUNNABLE;
    80203054:	00300793          	li	a5,3
    p->context.ra = (uint64)first_sched_ret;
    80203058:	00000717          	auipc	a4,0x0
    8020305c:	bc470713          	addi	a4,a4,-1084 # 80202c1c <first_sched_ret>
    p->state = RUNNABLE;
    80203060:	02f52023          	sw	a5,32(a0)
    p->parent = init_proc;
    80203064:	0001b797          	auipc	a5,0x1b
    80203068:	3447b783          	ld	a5,836(a5) # 8021e3a8 <init_proc>
    p->context.ra = (uint64)first_sched_ret;
    8020306c:	04e53c23          	sd	a4,88(a0)
    p->context.s2 = arg;
    80203070:	07253c23          	sd	s2,120(a0)
    p->parent = init_proc;
    80203074:	04f53023          	sd	a5,64(a0)
    p->context.s1 = (uint64)fn;
    80203078:	07353823          	sd	s3,112(a0)
    int pid = p->pid;
    8020307c:	00050493          	mv	s1,a0
    80203080:	02452903          	lw	s2,36(a0)
    add_task(p);
    80203084:	00001097          	auipc	ra,0x1
    80203088:	8c8080e7          	jalr	-1848(ra) # 8020394c <add_task>
    release(&p->lock);
    8020308c:	00048513          	mv	a0,s1
    80203090:	fffff097          	auipc	ra,0xfffff
    80203094:	bb0080e7          	jalr	-1104(ra) # 80201c40 <release>
    return pid;
    80203098:	01813483          	ld	s1,24(sp)
}
    8020309c:	02813083          	ld	ra,40(sp)
    802030a0:	02013403          	ld	s0,32(sp)
    802030a4:	00813983          	ld	s3,8(sp)
    802030a8:	00090513          	mv	a0,s2
    802030ac:	01013903          	ld	s2,16(sp)
    802030b0:	03010113          	addi	sp,sp,48
    802030b4:	00008067          	ret
        return -1;
    802030b8:	fff00913          	li	s2,-1
    802030bc:	fe1ff06f          	j	8020309c <create_kthread+0x88>

00000000802030c0 <sleep>:
    p->sleep_chan = NULL;
    p->killed     = 0;
    p->parent     = NULL;
}

void sleep(void *chan, spinlock_t *lk) {
    802030c0:	fd010113          	addi	sp,sp,-48
    802030c4:	02113423          	sd	ra,40(sp)
    802030c8:	02813023          	sd	s0,32(sp)
    802030cc:	00913c23          	sd	s1,24(sp)
    802030d0:	03010413          	addi	s0,sp,48
    802030d4:	01213823          	sd	s2,16(sp)
    802030d8:	01313423          	sd	s3,8(sp)
    802030dc:	00058913          	mv	s2,a1
    802030e0:	00050993          	mv	s3,a0
    push_off();
    802030e4:	fffff097          	auipc	ra,0xfffff
    802030e8:	880080e7          	jalr	-1920(ra) # 80201964 <push_off>
    struct cpu* c = mycpu();
    802030ec:	00001097          	auipc	ra,0x1
    802030f0:	000080e7          	jalr	ra # 802040ec <mycpu>
    struct proc* p = c->proc;
    802030f4:	00853483          	ld	s1,8(a0)
    pop_off();
    802030f8:	fffff097          	auipc	ra,0xfffff
    802030fc:	8e0080e7          	jalr	-1824(ra) # 802019d8 <pop_off>
    // Once we hold p->lock, we can be
    // guaranteed that we won't miss any wakeup
    // (wakeup locks p->lock),
    // so it's okay to release lk.

    acquire(&p->lock);  // DOC: sleeplock1
    80203100:	00048513          	mv	a0,s1
    80203104:	fffff097          	auipc	ra,0xfffff
    80203108:	9f8080e7          	jalr	-1544(ra) # 80201afc <acquire>
    release(lk);
    8020310c:	00090513          	mv	a0,s2
    80203110:	fffff097          	auipc	ra,0xfffff
    80203114:	b30080e7          	jalr	-1232(ra) # 80201c40 <release>

    // Go to sleep.
    p->sleep_chan = chan;
    p->state      = SLEEPING;
    80203118:	00200793          	li	a5,2
    p->sleep_chan = chan;
    8020311c:	0334b823          	sd	s3,48(s1)
    p->state      = SLEEPING;
    80203120:	02f4a023          	sw	a5,32(s1)

    sched();
    80203124:	00001097          	auipc	ra,0x1
    80203128:	c34080e7          	jalr	-972(ra) # 80203d58 <sched>

    // p get waking up, Tidy up.
    p->sleep_chan = 0;

    // Reacquire original lock.
    release(&p->lock);
    8020312c:	00048513          	mv	a0,s1
    p->sleep_chan = 0;
    80203130:	0204b823          	sd	zero,48(s1)
    release(&p->lock);
    80203134:	fffff097          	auipc	ra,0xfffff
    80203138:	b0c080e7          	jalr	-1268(ra) # 80201c40 <release>
    acquire(lk);
}
    8020313c:	02013403          	ld	s0,32(sp)
    80203140:	02813083          	ld	ra,40(sp)
    80203144:	01813483          	ld	s1,24(sp)
    80203148:	00813983          	ld	s3,8(sp)
    acquire(lk);
    8020314c:	00090513          	mv	a0,s2
}
    80203150:	01013903          	ld	s2,16(sp)
    80203154:	03010113          	addi	sp,sp,48
    acquire(lk);
    80203158:	fffff317          	auipc	t1,0xfffff
    8020315c:	9a430067          	jr	-1628(t1) # 80201afc <acquire>

0000000080203160 <wakeup>:

void wakeup(void *chan) {
    80203160:	fc010113          	addi	sp,sp,-64
    80203164:	02813823          	sd	s0,48(sp)
    80203168:	03213023          	sd	s2,32(sp)
    8020316c:	01313c23          	sd	s3,24(sp)
    80203170:	01413823          	sd	s4,16(sp)
    80203174:	01513423          	sd	s5,8(sp)
    80203178:	01613023          	sd	s6,0(sp)
    8020317c:	02113c23          	sd	ra,56(sp)
    80203180:	02913423          	sd	s1,40(sp)
    80203184:	04010413          	addi	s0,sp,64
    80203188:	00050a93          	mv	s5,a0
    8020318c:	00018917          	auipc	s2,0x18
    80203190:	f0c90913          	addi	s2,s2,-244 # 8021b098 <pool>
    80203194:	00019a17          	auipc	s4,0x19
    80203198:	f04a0a13          	addi	s4,s4,-252 # 8021c098 <task_queue>
    for (int i = 0; i < NPROC; i++) {
        struct proc *p = pool[i];
        acquire(&p->lock);
        if (p->state == SLEEPING && p->sleep_chan == chan) {
    8020319c:	00200993          	li	s3,2
            p->state = RUNNABLE;
    802031a0:	00300b13          	li	s6,3
    802031a4:	0180006f          	j	802031bc <wakeup+0x5c>
            add_task(p);
        }
        release(&p->lock);
    802031a8:	00048513          	mv	a0,s1
    for (int i = 0; i < NPROC; i++) {
    802031ac:	00890913          	addi	s2,s2,8
        release(&p->lock);
    802031b0:	fffff097          	auipc	ra,0xfffff
    802031b4:	a90080e7          	jalr	-1392(ra) # 80201c40 <release>
    for (int i = 0; i < NPROC; i++) {
    802031b8:	05490463          	beq	s2,s4,80203200 <wakeup+0xa0>
        struct proc *p = pool[i];
    802031bc:	00093483          	ld	s1,0(s2)
        acquire(&p->lock);
    802031c0:	00048513          	mv	a0,s1
    802031c4:	fffff097          	auipc	ra,0xfffff
    802031c8:	938080e7          	jalr	-1736(ra) # 80201afc <acquire>
        if (p->state == SLEEPING && p->sleep_chan == chan) {
    802031cc:	0204a783          	lw	a5,32(s1)
    802031d0:	fd379ce3          	bne	a5,s3,802031a8 <wakeup+0x48>
    802031d4:	0304b783          	ld	a5,48(s1)
    802031d8:	fd5798e3          	bne	a5,s5,802031a8 <wakeup+0x48>
            add_task(p);
    802031dc:	00048513          	mv	a0,s1
            p->state = RUNNABLE;
    802031e0:	0364a023          	sw	s6,32(s1)
            add_task(p);
    802031e4:	00000097          	auipc	ra,0x0
    802031e8:	768080e7          	jalr	1896(ra) # 8020394c <add_task>
        release(&p->lock);
    802031ec:	00048513          	mv	a0,s1
    for (int i = 0; i < NPROC; i++) {
    802031f0:	00890913          	addi	s2,s2,8
        release(&p->lock);
    802031f4:	fffff097          	auipc	ra,0xfffff
    802031f8:	a4c080e7          	jalr	-1460(ra) # 80201c40 <release>
    for (int i = 0; i < NPROC; i++) {
    802031fc:	fd4910e3          	bne	s2,s4,802031bc <wakeup+0x5c>
    }
}
    80203200:	03813083          	ld	ra,56(sp)
    80203204:	03013403          	ld	s0,48(sp)
    80203208:	02813483          	ld	s1,40(sp)
    8020320c:	02013903          	ld	s2,32(sp)
    80203210:	01813983          	ld	s3,24(sp)
    80203214:	01013a03          	ld	s4,16(sp)
    80203218:	00813a83          	ld	s5,8(sp)
    8020321c:	00013b03          	ld	s6,0(sp)
    80203220:	04010113          	addi	sp,sp,64
    80203224:	00008067          	ret

0000000080203228 <wait>:

int wait(int pid, int *code) {
    80203228:	f9010113          	addi	sp,sp,-112
    8020322c:	06113423          	sd	ra,104(sp)
    80203230:	06813023          	sd	s0,96(sp)
    80203234:	05313423          	sd	s3,72(sp)
    80203238:	07010413          	addi	s0,sp,112
    8020323c:	05413023          	sd	s4,64(sp)
    80203240:	03613823          	sd	s6,48(sp)
    80203244:	03713423          	sd	s7,40(sp)
    80203248:	03813023          	sd	s8,32(sp)
    8020324c:	01913c23          	sd	s9,24(sp)
    80203250:	01a13823          	sd	s10,16(sp)
    80203254:	04913c23          	sd	s1,88(sp)
    80203258:	05213823          	sd	s2,80(sp)
    8020325c:	03513c23          	sd	s5,56(sp)
    80203260:	01b13423          	sd	s11,8(sp)
    80203264:	00058c13          	mv	s8,a1
    80203268:	00050b93          	mv	s7,a0
    push_off();
    8020326c:	ffffe097          	auipc	ra,0xffffe
    80203270:	6f8080e7          	jalr	1784(ra) # 80201964 <push_off>
    struct cpu* c = mycpu();
    80203274:	00001097          	auipc	ra,0x1
    80203278:	e78080e7          	jalr	-392(ra) # 802040ec <mycpu>
    struct proc* p = c->proc;
    8020327c:	00853983          	ld	s3,8(a0)
    pop_off();
    80203280:	ffffe097          	auipc	ra,0xffffe
    80203284:	758080e7          	jalr	1880(ra) # 802019d8 <pop_off>
    struct proc *child;
    int havekids;
    struct proc *p = curr_proc();

    acquire(&wait_lock);
    80203288:	00018517          	auipc	a0,0x18
    8020328c:	d9850513          	addi	a0,a0,-616 # 8021b020 <wait_lock>
    80203290:	fffff097          	auipc	ra,0xfffff
    80203294:	86c080e7          	jalr	-1940(ra) # 80201afc <acquire>
    80203298:	00019a17          	auipc	s4,0x19
    8020329c:	e00a0a13          	addi	s4,s4,-512 # 8021c098 <task_queue>
                continue;

            acquire(&child->lock);
            if (child->parent == p) {
                havekids = 1;
                if (child->state == ZOMBIE && (pid <= 0 || child->pid == pid)) {
    802032a0:	00500b13          	li	s6,5
    release(lk);
    802032a4:	00018c97          	auipc	s9,0x18
    802032a8:	d7cc8c93          	addi	s9,s9,-644 # 8021b020 <wait_lock>
    p->state      = SLEEPING;
    802032ac:	00200d13          	li	s10,2
        for (int i = 0; i < NPROC; i++) {
    802032b0:	00018917          	auipc	s2,0x18
    802032b4:	de890913          	addi	s2,s2,-536 # 8021b098 <pool>
        havekids = 0;
    802032b8:	00000a93          	li	s5,0
    802032bc:	0180006f          	j	802032d4 <wait+0xac>
                    release(&child->lock);
                    release(&wait_lock);
                    return cpid;
                }
            }
            release(&child->lock);
    802032c0:	00048513          	mv	a0,s1
    802032c4:	fffff097          	auipc	ra,0xfffff
    802032c8:	97c080e7          	jalr	-1668(ra) # 80201c40 <release>
        for (int i = 0; i < NPROC; i++) {
    802032cc:	00890913          	addi	s2,s2,8
    802032d0:	0d490c63          	beq	s2,s4,802033a8 <wait+0x180>
            child = pool[i];
    802032d4:	00093483          	ld	s1,0(s2)
            if (child == p)
    802032d8:	ff348ae3          	beq	s1,s3,802032cc <wait+0xa4>
            acquire(&child->lock);
    802032dc:	00048513          	mv	a0,s1
    802032e0:	fffff097          	auipc	ra,0xfffff
    802032e4:	81c080e7          	jalr	-2020(ra) # 80201afc <acquire>
            if (child->parent == p) {
    802032e8:	0404b783          	ld	a5,64(s1)
    802032ec:	fd379ae3          	bne	a5,s3,802032c0 <wait+0x98>
                if (child->state == ZOMBIE && (pid <= 0 || child->pid == pid)) {
    802032f0:	0204a783          	lw	a5,32(s1)
                havekids = 1;
    802032f4:	00100a93          	li	s5,1
                if (child->state == ZOMBIE && (pid <= 0 || child->pid == pid)) {
    802032f8:	fd6794e3          	bne	a5,s6,802032c0 <wait+0x98>
    802032fc:	0244ad83          	lw	s11,36(s1)
    80203300:	01705463          	blez	s7,80203308 <wait+0xe0>
    80203304:	fb7d9ee3          	bne	s11,s7,802032c0 <wait+0x98>
                    if (code)
    80203308:	000c0663          	beqz	s8,80203314 <wait+0xec>
                        *code = child->exit_code;
    8020330c:	0284b783          	ld	a5,40(s1)
    80203310:	00fc2023          	sw	a5,0(s8)
    assert(holding(&p->lock));
    80203314:	00048513          	mv	a0,s1
    80203318:	ffffe097          	auipc	ra,0xffffe
    8020331c:	600080e7          	jalr	1536(ra) # 80201918 <holding>
    80203320:	12050063          	beqz	a0,80203440 <wait+0x218>
    p->exit_code  = 0xdeadbeef;
    80203324:	37ab77b7          	lui	a5,0x37ab7
    80203328:	00279793          	slli	a5,a5,0x2
    p->state      = UNUSED;
    8020332c:	fff00713          	li	a4,-1
    p->exit_code  = 0xdeadbeef;
    80203330:	eef78793          	addi	a5,a5,-273 # 37ab6eef <_entry-0x48749111>
    p->state      = UNUSED;
    80203334:	02071713          	slli	a4,a4,0x20
                    release(&child->lock);
    80203338:	00048513          	mv	a0,s1
    p->state      = UNUSED;
    8020333c:	02e4b023          	sd	a4,32(s1)
    p->exit_code  = 0xdeadbeef;
    80203340:	02f4b423          	sd	a5,40(s1)
    p->sleep_chan = NULL;
    80203344:	0204b823          	sd	zero,48(s1)
    p->killed     = 0;
    80203348:	0204ac23          	sw	zero,56(s1)
    p->parent     = NULL;
    8020334c:	0404b023          	sd	zero,64(s1)
                    release(&child->lock);
    80203350:	fffff097          	auipc	ra,0xfffff
    80203354:	8f0080e7          	jalr	-1808(ra) # 80201c40 <release>
                    release(&wait_lock);
    80203358:	00018517          	auipc	a0,0x18
    8020335c:	cc850513          	addi	a0,a0,-824 # 8021b020 <wait_lock>
    80203360:	fffff097          	auipc	ra,0xfffff
    80203364:	8e0080e7          	jalr	-1824(ra) # 80201c40 <release>

        debugf("pid %d sleeps for wait", p->pid);
        // Wait for a child to exit.
        sleep(p, &wait_lock);  // DOC: wait-sleep
    }
}
    80203368:	06813083          	ld	ra,104(sp)
    8020336c:	06013403          	ld	s0,96(sp)
    80203370:	05813483          	ld	s1,88(sp)
    80203374:	05013903          	ld	s2,80(sp)
    80203378:	04813983          	ld	s3,72(sp)
    8020337c:	04013a03          	ld	s4,64(sp)
    80203380:	03813a83          	ld	s5,56(sp)
    80203384:	03013b03          	ld	s6,48(sp)
    80203388:	02813b83          	ld	s7,40(sp)
    8020338c:	02013c03          	ld	s8,32(sp)
    80203390:	01813c83          	ld	s9,24(sp)
    80203394:	01013d03          	ld	s10,16(sp)
    80203398:	000d8513          	mv	a0,s11
    8020339c:	00813d83          	ld	s11,8(sp)
    802033a0:	07010113          	addi	sp,sp,112
    802033a4:	00008067          	ret
        if (!havekids || p->killed) {
    802033a8:	080a8063          	beqz	s5,80203428 <wait+0x200>
    802033ac:	0389a783          	lw	a5,56(s3)
    802033b0:	06079c63          	bnez	a5,80203428 <wait+0x200>
        debugf("pid %d sleeps for wait", p->pid);
    802033b4:	0249a583          	lw	a1,36(s3)
    802033b8:	00000513          	li	a0,0
    802033bc:	00001097          	auipc	ra,0x1
    802033c0:	190080e7          	jalr	400(ra) # 8020454c <dummy>
    push_off();
    802033c4:	ffffe097          	auipc	ra,0xffffe
    802033c8:	5a0080e7          	jalr	1440(ra) # 80201964 <push_off>
    struct cpu* c = mycpu();
    802033cc:	00001097          	auipc	ra,0x1
    802033d0:	d20080e7          	jalr	-736(ra) # 802040ec <mycpu>
    struct proc* p = c->proc;
    802033d4:	00853483          	ld	s1,8(a0)
    pop_off();
    802033d8:	ffffe097          	auipc	ra,0xffffe
    802033dc:	600080e7          	jalr	1536(ra) # 802019d8 <pop_off>
    acquire(&p->lock);  // DOC: sleeplock1
    802033e0:	00048513          	mv	a0,s1
    802033e4:	ffffe097          	auipc	ra,0xffffe
    802033e8:	718080e7          	jalr	1816(ra) # 80201afc <acquire>
    release(lk);
    802033ec:	000c8513          	mv	a0,s9
    802033f0:	fffff097          	auipc	ra,0xfffff
    802033f4:	850080e7          	jalr	-1968(ra) # 80201c40 <release>
    p->sleep_chan = chan;
    802033f8:	0334b823          	sd	s3,48(s1)
    p->state      = SLEEPING;
    802033fc:	03a4a023          	sw	s10,32(s1)
    sched();
    80203400:	00001097          	auipc	ra,0x1
    80203404:	958080e7          	jalr	-1704(ra) # 80203d58 <sched>
    release(&p->lock);
    80203408:	00048513          	mv	a0,s1
    p->sleep_chan = 0;
    8020340c:	0204b823          	sd	zero,48(s1)
    release(&p->lock);
    80203410:	fffff097          	auipc	ra,0xfffff
    80203414:	830080e7          	jalr	-2000(ra) # 80201c40 <release>
    acquire(lk);
    80203418:	000c8513          	mv	a0,s9
    8020341c:	ffffe097          	auipc	ra,0xffffe
    80203420:	6e0080e7          	jalr	1760(ra) # 80201afc <acquire>
}
    80203424:	e8dff06f          	j	802032b0 <wait+0x88>
            release(&wait_lock);
    80203428:	00018517          	auipc	a0,0x18
    8020342c:	bf850513          	addi	a0,a0,-1032 # 8021b020 <wait_lock>
    80203430:	fffff097          	auipc	ra,0xfffff
    80203434:	810080e7          	jalr	-2032(ra) # 80201c40 <release>
            return -1;
    80203438:	fff00d93          	li	s11,-1
    8020343c:	f2dff06f          	j	80203368 <wait+0x140>
    80203440:	00020493          	mv	s1,tp
    return r_tp();
    80203444:	0004849b          	sext.w	s1,s1
    struct proc *p = curr_proc();
    80203448:	fffff097          	auipc	ra,0xfffff
    8020344c:	78c080e7          	jalr	1932(ra) # 80202bd4 <curr_proc>
    return p ? p->pid : -1;
    80203450:	02050e63          	beqz	a0,8020348c <wait+0x264>
    80203454:	02452703          	lw	a4,36(a0)
    assert(holding(&p->lock));
    80203458:	00003897          	auipc	a7,0x3
    8020345c:	8c088893          	addi	a7,a7,-1856 # 80205d18 <e_text+0xd18>
    80203460:	07f00813          	li	a6,127
    80203464:	00002797          	auipc	a5,0x2
    80203468:	7f478793          	addi	a5,a5,2036 # 80205c58 <e_text+0xc58>
    8020346c:	00048693          	mv	a3,s1
    80203470:	00002617          	auipc	a2,0x2
    80203474:	bb860613          	addi	a2,a2,-1096 # 80205028 <e_text+0x28>
    80203478:	01f00593          	li	a1,31
    8020347c:	00002517          	auipc	a0,0x2
    80203480:	bb450513          	addi	a0,a0,-1100 # 80205030 <e_text+0x30>
    80203484:	fffff097          	auipc	ra,0xfffff
    80203488:	400080e7          	jalr	1024(ra) # 80202884 <__panic>
    8020348c:	fff00713          	li	a4,-1
    80203490:	fc9ff06f          	j	80203458 <wait+0x230>

0000000080203494 <exit>:

// Exit the current process.
void exit(int code) {
    80203494:	fb010113          	addi	sp,sp,-80
    80203498:	04813023          	sd	s0,64(sp)
    8020349c:	01513c23          	sd	s5,24(sp)
    802034a0:	01713423          	sd	s7,8(sp)
    802034a4:	04113423          	sd	ra,72(sp)
    802034a8:	05010413          	addi	s0,sp,80
    802034ac:	00050b93          	mv	s7,a0
    struct proc *p = curr_proc();

    if (p == init_proc) {
    802034b0:	0001ba97          	auipc	s5,0x1b
    802034b4:	ef8a8a93          	addi	s5,s5,-264 # 8021e3a8 <init_proc>
    struct proc *p = curr_proc();
    802034b8:	fffff097          	auipc	ra,0xfffff
    802034bc:	71c080e7          	jalr	1820(ra) # 80202bd4 <curr_proc>
    if (p == init_proc) {
    802034c0:	000ab783          	ld	a5,0(s5)
    802034c4:	02913c23          	sd	s1,56(sp)
    802034c8:	03213823          	sd	s2,48(sp)
    802034cc:	03313423          	sd	s3,40(sp)
    802034d0:	03413023          	sd	s4,32(sp)
    802034d4:	01613823          	sd	s6,16(sp)
    802034d8:	10a78863          	beq	a5,a0,802035e8 <exit+0x154>
    802034dc:	00050993          	mv	s3,a0
        panic("init process exited");
    }

    acquire(&wait_lock);
    802034e0:	00018517          	auipc	a0,0x18
    802034e4:	b4050513          	addi	a0,a0,-1216 # 8021b020 <wait_lock>
    802034e8:	ffffe097          	auipc	ra,0xffffe
    802034ec:	614080e7          	jalr	1556(ra) # 80201afc <acquire>

    int wakeinit = 0;

    // reparent:
    for (int i = 0; i < NPROC; i++) {
    802034f0:	00018917          	auipc	s2,0x18
    802034f4:	ba890913          	addi	s2,s2,-1112 # 8021b098 <pool>
    802034f8:	00019a17          	auipc	s4,0x19
    802034fc:	ba0a0a13          	addi	s4,s4,-1120 # 8021c098 <task_queue>
    int wakeinit = 0;
    80203500:	00000b13          	li	s6,0
    80203504:	0180006f          	j	8020351c <exit+0x88>
        if (child->parent == p){
            child->parent = init_proc;
            wakeinit = 1;
            // if child has dead, wake up init to do clean up.
        }
        release(&child->lock);
    80203508:	00048513          	mv	a0,s1
    8020350c:	ffffe097          	auipc	ra,0xffffe
    80203510:	734080e7          	jalr	1844(ra) # 80201c40 <release>
    for (int i = 0; i < NPROC; i++) {
    80203514:	00890913          	addi	s2,s2,8
    80203518:	03490863          	beq	s2,s4,80203548 <exit+0xb4>
        struct proc *child = pool[i];
    8020351c:	00093483          	ld	s1,0(s2)
        if (child == p)
    80203520:	fe998ae3          	beq	s3,s1,80203514 <exit+0x80>
        acquire(&child->lock);
    80203524:	00048513          	mv	a0,s1
    80203528:	ffffe097          	auipc	ra,0xffffe
    8020352c:	5d4080e7          	jalr	1492(ra) # 80201afc <acquire>
        if (child->parent == p){
    80203530:	0404b783          	ld	a5,64(s1)
    80203534:	fd379ae3          	bne	a5,s3,80203508 <exit+0x74>
            child->parent = init_proc;
    80203538:	000ab783          	ld	a5,0(s5)
            wakeinit = 1;
    8020353c:	00100b13          	li	s6,1
            child->parent = init_proc;
    80203540:	04f4b023          	sd	a5,64(s1)
            wakeinit = 1;
    80203544:	fc5ff06f          	j	80203508 <exit+0x74>
    }
    if (wakeinit)
    80203548:	080b1863          	bnez	s6,802035d8 <exit+0x144>
        wakeup(init_proc);

    // wakeup wait-ing parent.
    //  There is no race because locking against "wait_lock"
    wakeup(p->parent);
    8020354c:	0409b503          	ld	a0,64(s3)
    80203550:	00000097          	auipc	ra,0x0
    80203554:	c10080e7          	jalr	-1008(ra) # 80203160 <wakeup>

    acquire(&p->lock);
    80203558:	00098513          	mv	a0,s3
    8020355c:	ffffe097          	auipc	ra,0xffffe
    80203560:	5a0080e7          	jalr	1440(ra) # 80201afc <acquire>

    p->exit_code = code;
    p->state     = ZOMBIE;
    80203564:	00500793          	li	a5,5
    p->exit_code = code;
    80203568:	0379b423          	sd	s7,40(s3)
    p->state     = ZOMBIE;
    8020356c:	02f9a023          	sw	a5,32(s3)

    release(&wait_lock);
    80203570:	00018517          	auipc	a0,0x18
    80203574:	ab050513          	addi	a0,a0,-1360 # 8021b020 <wait_lock>
    80203578:	ffffe097          	auipc	ra,0xffffe
    8020357c:	6c8080e7          	jalr	1736(ra) # 80201c40 <release>
    asm volatile("csrr %0, sstatus" : "=r"(x));
    80203580:	100027f3          	csrr	a5,sstatus
    // checkpoint2
    // 调用sched()之前，确保SSP位被设置（supervisor模式）
    uint64 x = r_sstatus();
    x |= SSTATUS_SPP;  // 设置SSP位为1，表示在supervisor模式下运行
    80203584:	1007e793          	ori	a5,a5,256
    asm volatile("csrw sstatus, %0" : : "r"(x));
    80203588:	10079073          	csrw	sstatus,a5
    w_sstatus(x);

    sched();
    8020358c:	00000097          	auipc	ra,0x0
    80203590:	7cc080e7          	jalr	1996(ra) # 80203d58 <sched>
    asm volatile("mv %0, tp" : "=r"(x));
    80203594:	00020493          	mv	s1,tp
    80203598:	0004849b          	sext.w	s1,s1
    struct proc *p = curr_proc();
    8020359c:	fffff097          	auipc	ra,0xfffff
    802035a0:	638080e7          	jalr	1592(ra) # 80202bd4 <curr_proc>
    return p ? p->pid : -1;
    802035a4:	08050463          	beqz	a0,8020362c <exit+0x198>
    802035a8:	02452703          	lw	a4,36(a0)
    panic_never_reach();
    802035ac:	10900813          	li	a6,265
    802035b0:	00002797          	auipc	a5,0x2
    802035b4:	6a878793          	addi	a5,a5,1704 # 80205c58 <e_text+0xc58>
    802035b8:	00048693          	mv	a3,s1
    802035bc:	00002617          	auipc	a2,0x2
    802035c0:	a6c60613          	addi	a2,a2,-1428 # 80205028 <e_text+0x28>
    802035c4:	01f00593          	li	a1,31
    802035c8:	00002517          	auipc	a0,0x2
    802035cc:	79850513          	addi	a0,a0,1944 # 80205d60 <e_text+0xd60>
    802035d0:	fffff097          	auipc	ra,0xfffff
    802035d4:	2b4080e7          	jalr	692(ra) # 80202884 <__panic>
        wakeup(init_proc);
    802035d8:	000ab503          	ld	a0,0(s5)
    802035dc:	00000097          	auipc	ra,0x0
    802035e0:	b84080e7          	jalr	-1148(ra) # 80203160 <wakeup>
    802035e4:	f69ff06f          	j	8020354c <exit+0xb8>
    802035e8:	00020493          	mv	s1,tp
    802035ec:	0004849b          	sext.w	s1,s1
    struct proc *p = curr_proc();
    802035f0:	fffff097          	auipc	ra,0xfffff
    802035f4:	5e4080e7          	jalr	1508(ra) # 80202bd4 <curr_proc>
    return p ? p->pid : -1;
    802035f8:	02050e63          	beqz	a0,80203634 <exit+0x1a0>
    802035fc:	02452703          	lw	a4,36(a0)
        panic("init process exited");
    80203600:	0e100813          	li	a6,225
    80203604:	00002797          	auipc	a5,0x2
    80203608:	65478793          	addi	a5,a5,1620 # 80205c58 <e_text+0xc58>
    8020360c:	00048693          	mv	a3,s1
    80203610:	00002617          	auipc	a2,0x2
    80203614:	a1860613          	addi	a2,a2,-1512 # 80205028 <e_text+0x28>
    80203618:	01f00593          	li	a1,31
    8020361c:	00002517          	auipc	a0,0x2
    80203620:	71450513          	addi	a0,a0,1812 # 80205d30 <e_text+0xd30>
    80203624:	fffff097          	auipc	ra,0xfffff
    80203628:	260080e7          	jalr	608(ra) # 80202884 <__panic>
    8020362c:	fff00713          	li	a4,-1
    80203630:	f7dff06f          	j	802035ac <exit+0x118>
    80203634:	fff00713          	li	a4,-1
    80203638:	fc9ff06f          	j	80203600 <exit+0x16c>

000000008020363c <init_queue>:

#include "defs.h"
#include "log.h"
#include "proc.h"

void init_queue(struct queue *q) {
    8020363c:	fe010113          	addi	sp,sp,-32
    80203640:	00813823          	sd	s0,16(sp)
    80203644:	00913423          	sd	s1,8(sp)
    80203648:	00113c23          	sd	ra,24(sp)
    8020364c:	02010413          	addi	s0,sp,32
    spinlock_init(&q->lock, "queue");
    80203650:	00002597          	auipc	a1,0x2
    80203654:	74858593          	addi	a1,a1,1864 # 80205d98 <e_text+0xd98>
void init_queue(struct queue *q) {
    80203658:	00050493          	mv	s1,a0
    spinlock_init(&q->lock, "queue");
    8020365c:	ffffe097          	auipc	ra,0xffffe
    80203660:	268080e7          	jalr	616(ra) # 802018c4 <spinlock_init>
    q->front = q->tail = 0;
    q->empty           = 1;
}
    80203664:	01813083          	ld	ra,24(sp)
    80203668:	01013403          	ld	s0,16(sp)
    q->front = q->tail = 0;
    8020366c:	000027b7          	lui	a5,0x2
    80203670:	00f48533          	add	a0,s1,a5
    q->empty           = 1;
    80203674:	00100793          	li	a5,1
    q->front = q->tail = 0;
    80203678:	02053023          	sd	zero,32(a0)
    q->empty           = 1;
    8020367c:	02f52423          	sw	a5,40(a0)
}
    80203680:	00813483          	ld	s1,8(sp)
    80203684:	02010113          	addi	sp,sp,32
    80203688:	00008067          	ret

000000008020368c <push_queue>:

void push_queue(struct queue *q, void *data) {
    8020368c:	fe010113          	addi	sp,sp,-32
    80203690:	00813823          	sd	s0,16(sp)
    80203694:	00913423          	sd	s1,8(sp)
    80203698:	01213023          	sd	s2,0(sp)
    8020369c:	00113c23          	sd	ra,24(sp)
    802036a0:	02010413          	addi	s0,sp,32
    802036a4:	00050493          	mv	s1,a0
    802036a8:	00058913          	mv	s2,a1
    acquire(&q->lock);
    802036ac:	ffffe097          	auipc	ra,0xffffe
    802036b0:	450080e7          	jalr	1104(ra) # 80201afc <acquire>
    if (!q->empty && q->front == q->tail) {
    802036b4:	00002737          	lui	a4,0x2
    802036b8:	00e48733          	add	a4,s1,a4
    802036bc:	02872783          	lw	a5,40(a4) # 2028 <_entry-0x801fdfd8>
    802036c0:	06079463          	bnez	a5,80203728 <push_queue+0x9c>
    802036c4:	02472783          	lw	a5,36(a4)
    802036c8:	02072703          	lw	a4,32(a4)
    802036cc:	06f70263          	beq	a4,a5,80203730 <push_queue+0xa4>
        panic("queue overflow");
    }
    q->empty         = 0;
    q->data[q->tail] = data;
    q->tail          = (q->tail + 1) % NPROC;
    802036d0:	0017871b          	addiw	a4,a5,1 # 2001 <_entry-0x801fdfff>
    802036d4:	41f7561b          	sraiw	a2,a4,0x1f
    802036d8:	0176561b          	srliw	a2,a2,0x17
    q->data[q->tail] = data;
    802036dc:	00478793          	addi	a5,a5,4
    q->empty         = 0;
    802036e0:	000026b7          	lui	a3,0x2
    802036e4:	00d486b3          	add	a3,s1,a3
    q->data[q->tail] = data;
    802036e8:	00379793          	slli	a5,a5,0x3
    q->tail          = (q->tail + 1) % NPROC;
    802036ec:	00c7073b          	addw	a4,a4,a2
    release(&q->lock);
}
    802036f0:	01013403          	ld	s0,16(sp)
    q->empty         = 0;
    802036f4:	0206a423          	sw	zero,40(a3) # 2028 <_entry-0x801fdfd8>
    q->data[q->tail] = data;
    802036f8:	00f487b3          	add	a5,s1,a5
    q->tail          = (q->tail + 1) % NPROC;
    802036fc:	1ff77713          	andi	a4,a4,511
    q->data[q->tail] = data;
    80203700:	0127b023          	sd	s2,0(a5)
}
    80203704:	01813083          	ld	ra,24(sp)
    80203708:	00013903          	ld	s2,0(sp)
    q->tail          = (q->tail + 1) % NPROC;
    8020370c:	40c7073b          	subw	a4,a4,a2
    release(&q->lock);
    80203710:	00048513          	mv	a0,s1
}
    80203714:	00813483          	ld	s1,8(sp)
    q->tail          = (q->tail + 1) % NPROC;
    80203718:	02e6a223          	sw	a4,36(a3)
}
    8020371c:	02010113          	addi	sp,sp,32
    release(&q->lock);
    80203720:	ffffe317          	auipc	t1,0xffffe
    80203724:	52030067          	jr	1312(t1) # 80201c40 <release>
    if (!q->empty && q->front == q->tail) {
    80203728:	02472783          	lw	a5,36(a4)
    8020372c:	fa5ff06f          	j	802036d0 <push_queue+0x44>
    80203730:	00020493          	mv	s1,tp
    push_off();
    80203734:	ffffe097          	auipc	ra,0xffffe
    80203738:	230080e7          	jalr	560(ra) # 80201964 <push_off>
    struct cpu* c = mycpu();
    8020373c:	00001097          	auipc	ra,0x1
    80203740:	9b0080e7          	jalr	-1616(ra) # 802040ec <mycpu>
    struct proc* p = c->proc;
    80203744:	00853903          	ld	s2,8(a0)
    return r_tp();
    80203748:	0004849b          	sext.w	s1,s1
    pop_off();
    8020374c:	ffffe097          	auipc	ra,0xffffe
    80203750:	28c080e7          	jalr	652(ra) # 802019d8 <pop_off>
    80203754:	02090a63          	beqz	s2,80203788 <push_queue+0xfc>
    80203758:	02492703          	lw	a4,36(s2)
        panic("queue overflow");
    8020375c:	01000813          	li	a6,16
    80203760:	00002797          	auipc	a5,0x2
    80203764:	64078793          	addi	a5,a5,1600 # 80205da0 <e_text+0xda0>
    80203768:	00048693          	mv	a3,s1
    8020376c:	00002617          	auipc	a2,0x2
    80203770:	8bc60613          	addi	a2,a2,-1860 # 80205028 <e_text+0x28>
    80203774:	01f00593          	li	a1,31
    80203778:	00002517          	auipc	a0,0x2
    8020377c:	63850513          	addi	a0,a0,1592 # 80205db0 <e_text+0xdb0>
    80203780:	fffff097          	auipc	ra,0xfffff
    80203784:	104080e7          	jalr	260(ra) # 80202884 <__panic>
    80203788:	fff00713          	li	a4,-1
    8020378c:	fd1ff06f          	j	8020375c <push_queue+0xd0>

0000000080203790 <pop_queue>:

void *pop_queue(struct queue *q) {
    80203790:	fe010113          	addi	sp,sp,-32
    80203794:	00813823          	sd	s0,16(sp)
    80203798:	00913423          	sd	s1,8(sp)
    8020379c:	00113c23          	sd	ra,24(sp)
    802037a0:	01213023          	sd	s2,0(sp)
    802037a4:	02010413          	addi	s0,sp,32
    802037a8:	00050493          	mv	s1,a0
    acquire(&q->lock);
    802037ac:	ffffe097          	auipc	ra,0xffffe
    802037b0:	350080e7          	jalr	848(ra) # 80201afc <acquire>
    if (q->empty) {
    802037b4:	000026b7          	lui	a3,0x2
    802037b8:	00d486b3          	add	a3,s1,a3
    802037bc:	0286a783          	lw	a5,40(a3) # 2028 <_entry-0x801fdfd8>
    802037c0:	06079863          	bnez	a5,80203830 <pop_queue+0xa0>
        release(&q->lock);
        return NULL;
    }

    void *data = q->data[q->front];
    802037c4:	0206a703          	lw	a4,32(a3)
    q->front   = (q->front + 1) % NPROC;
    if (q->front == q->tail)
    802037c8:	0246a583          	lw	a1,36(a3)
    q->front   = (q->front + 1) % NPROC;
    802037cc:	0017079b          	addiw	a5,a4,1
    802037d0:	41f7d61b          	sraiw	a2,a5,0x1f
    802037d4:	0176561b          	srliw	a2,a2,0x17
    void *data = q->data[q->front];
    802037d8:	00470713          	addi	a4,a4,4
    q->front   = (q->front + 1) % NPROC;
    802037dc:	00c787bb          	addw	a5,a5,a2
    void *data = q->data[q->front];
    802037e0:	00371713          	slli	a4,a4,0x3
    q->front   = (q->front + 1) % NPROC;
    802037e4:	1ff7f793          	andi	a5,a5,511
    802037e8:	40c787bb          	subw	a5,a5,a2
    void *data = q->data[q->front];
    802037ec:	00e48733          	add	a4,s1,a4
    802037f0:	00073903          	ld	s2,0(a4)
    q->front   = (q->front + 1) % NPROC;
    802037f4:	0007871b          	sext.w	a4,a5
    802037f8:	02f6a023          	sw	a5,32(a3)
    if (q->front == q->tail)
    802037fc:	00e59663          	bne	a1,a4,80203808 <pop_queue+0x78>
        q->empty = 1;
    80203800:	00100793          	li	a5,1
    80203804:	02f6a423          	sw	a5,40(a3)
    release(&q->lock);
    80203808:	00048513          	mv	a0,s1
    8020380c:	ffffe097          	auipc	ra,0xffffe
    80203810:	434080e7          	jalr	1076(ra) # 80201c40 <release>
    return data;
}
    80203814:	01813083          	ld	ra,24(sp)
    80203818:	01013403          	ld	s0,16(sp)
    8020381c:	00813483          	ld	s1,8(sp)
    80203820:	00090513          	mv	a0,s2
    80203824:	00013903          	ld	s2,0(sp)
    80203828:	02010113          	addi	sp,sp,32
    8020382c:	00008067          	ret
        release(&q->lock);
    80203830:	00048513          	mv	a0,s1
    80203834:	ffffe097          	auipc	ra,0xffffe
    80203838:	40c080e7          	jalr	1036(ra) # 80201c40 <release>
        return NULL;
    8020383c:	00000913          	li	s2,0
    80203840:	fd5ff06f          	j	80203814 <pop_queue+0x84>

0000000080203844 <sbi_putchar>:
	ret.error = a0;
	ret.value = a1;
	return ret;
}
void sbi_putchar(int c)
{
    80203844:	ff010113          	addi	sp,sp,-16
    80203848:	00813423          	sd	s0,8(sp)
    8020384c:	01010413          	addi	s0,sp,16
	register uint64 a1 asm("a1") = arg1;
    80203850:	00000593          	li	a1,0
	register uint64 a2 asm("a2") = arg2;
    80203854:	00000613          	li	a2,0
	register uint64 a7 asm("a7") = which;
    80203858:	00100893          	li	a7,1
	asm volatile("ecall" : "=r"(a0) : "r"(a0), "r"(a1), "r"(a2), "r"(a7) : "memory");
    8020385c:	00000073          	ecall
	sbi_call_legacy(SBI_CONSOLE_PUTCHAR, c, 0, 0);
}
    80203860:	00813403          	ld	s0,8(sp)
    80203864:	01010113          	addi	sp,sp,16
    80203868:	00008067          	ret

000000008020386c <sbi_hsm_hart_start>:

int sbi_hsm_hart_start(unsigned long hartid, unsigned long start_addr, unsigned long a1)
{
    8020386c:	ff010113          	addi	sp,sp,-16
    80203870:	00813423          	sd	s0,8(sp)
	register uint64 a7 asm("a7") = eid;
    80203874:	004858b7          	lui	a7,0x485
{
    80203878:	01010413          	addi	s0,sp,16
	register uint64 a6 asm("a6") = fid;
    8020387c:	00000813          	li	a6,0
	register uint64 a7 asm("a7") = eid;
    80203880:	34d88893          	addi	a7,a7,845 # 48534d <_entry-0x7fd7acb3>
	asm volatile("ecall" : "=r"(a0), "=r"(a1) : "r"(a0), "r"(a1), "r"(a2), "r"(a6), "r"(a7) : "memory");
    80203884:	00000073          	ecall
	struct sbiret ret = sbi_call(SBI_HSM, 0x0, hartid, start_addr, a1);
	return ret.error;
}
    80203888:	00813403          	ld	s0,8(sp)
    8020388c:	0005051b          	sext.w	a0,a0
    80203890:	01010113          	addi	sp,sp,16
    80203894:	00008067          	ret

0000000080203898 <shutdown>:

void shutdown()
{
    80203898:	ff010113          	addi	sp,sp,-16
    8020389c:	00813423          	sd	s0,8(sp)
    802038a0:	01010413          	addi	s0,sp,16
    asm volatile("csrrc %0, sstatus, %1" : "=r"(prev) : "r"(SSTATUS_SIE));
    802038a4:	00200793          	li	a5,2
    802038a8:	1007b7f3          	csrrc	a5,sstatus,a5
	intr_off();
	while (1)
		asm volatile("nop" ::: "memory");
    802038ac:	00000013          	nop
    802038b0:	00000013          	nop
	while (1)
    802038b4:	ff9ff06f          	j	802038ac <shutdown+0x14>

00000000802038b8 <set_timer>:
	sbi_call_legacy(SBI_SHUTDOWN, 0, 0, 0);
}

void set_timer(uint64 stime)
{
    802038b8:	ff010113          	addi	sp,sp,-16
    802038bc:	00813423          	sd	s0,8(sp)
    802038c0:	01010413          	addi	s0,sp,16
	register uint64 a1 asm("a1") = arg1;
    802038c4:	00000593          	li	a1,0
	register uint64 a2 asm("a2") = arg2;
    802038c8:	00000613          	li	a2,0
	register uint64 a7 asm("a7") = which;
    802038cc:	00000893          	li	a7,0
	asm volatile("ecall" : "=r"(a0) : "r"(a0), "r"(a1), "r"(a2), "r"(a7) : "memory");
    802038d0:	00000073          	ecall
	sbi_call_legacy(SBI_SET_TIMER, stime, 0, 0);
    802038d4:	00813403          	ld	s0,8(sp)
    802038d8:	01010113          	addi	sp,sp,16
    802038dc:	00008067          	ret

00000000802038e0 <curr_proc>:
                // nothing to run; stop running on this core until an interrupt.
                intr_on();
                asm volatile("wfi");
                intr_off();
                continue;
            }
    802038e0:	fe010113          	addi	sp,sp,-32
    802038e4:	00113c23          	sd	ra,24(sp)
    802038e8:	00813823          	sd	s0,16(sp)
    802038ec:	00913423          	sd	s1,8(sp)
    802038f0:	02010413          	addi	s0,sp,32
        }
    802038f4:	ffffe097          	auipc	ra,0xffffe
    802038f8:	070080e7          	jalr	112(ra) # 80201964 <push_off>

    802038fc:	00000097          	auipc	ra,0x0
    80203900:	7f0080e7          	jalr	2032(ra) # 802040ec <mycpu>
        acquire(&p->lock);
    80203904:	00853483          	ld	s1,8(a0)
        assert(p->state == RUNNABLE);
    80203908:	ffffe097          	auipc	ra,0xffffe
    8020390c:	0d0080e7          	jalr	208(ra) # 802019d8 <pop_off>
        logf(PURPLE, "sched", "switch to proc pid(%d)", p->pid);
        p->state = RUNNING;
    80203910:	01813083          	ld	ra,24(sp)
    80203914:	01013403          	ld	s0,16(sp)
    80203918:	00048513          	mv	a0,s1
    8020391c:	00813483          	ld	s1,8(sp)
    80203920:	02010113          	addi	sp,sp,32
    80203924:	00008067          	ret

0000000080203928 <sched_init>:
void sched_init() {
    80203928:	ff010113          	addi	sp,sp,-16
    8020392c:	00813423          	sd	s0,8(sp)
    80203930:	01010413          	addi	s0,sp,16
}
    80203934:	00813403          	ld	s0,8(sp)
    init_queue(&task_queue);
    80203938:	00018517          	auipc	a0,0x18
    8020393c:	76050513          	addi	a0,a0,1888 # 8021c098 <task_queue>
}
    80203940:	01010113          	addi	sp,sp,16
    init_queue(&task_queue);
    80203944:	00000317          	auipc	t1,0x0
    80203948:	cf830067          	jr	-776(t1) # 8020363c <init_queue>

000000008020394c <add_task>:
void add_task(struct proc *p) {
    8020394c:	fe010113          	addi	sp,sp,-32
    80203950:	00813823          	sd	s0,16(sp)
    80203954:	00113c23          	sd	ra,24(sp)
    80203958:	00913423          	sd	s1,8(sp)
    8020395c:	02010413          	addi	s0,sp,32
    assert(p->state == RUNNABLE);
    80203960:	02052703          	lw	a4,32(a0)
    80203964:	00300793          	li	a5,3
    80203968:	04f71463          	bne	a4,a5,802039b0 <add_task+0x64>
    assert(holding(&p->lock));
    8020396c:	00050493          	mv	s1,a0
    80203970:	ffffe097          	auipc	ra,0xffffe
    80203974:	fa8080e7          	jalr	-88(ra) # 80201918 <holding>
    80203978:	08050263          	beqz	a0,802039fc <add_task+0xb0>
    push_queue(&task_queue, p);
    8020397c:	00048593          	mv	a1,s1
    80203980:	00018517          	auipc	a0,0x18
    80203984:	71850513          	addi	a0,a0,1816 # 8021c098 <task_queue>
    80203988:	00000097          	auipc	ra,0x0
    8020398c:	d04080e7          	jalr	-764(ra) # 8020368c <push_queue>
}
    80203990:	01013403          	ld	s0,16(sp)
    debugf("add task (pid=%d) to task queue", p->pid);
    80203994:	0244a583          	lw	a1,36(s1)
}
    80203998:	01813083          	ld	ra,24(sp)
    8020399c:	00813483          	ld	s1,8(sp)
    debugf("add task (pid=%d) to task queue", p->pid);
    802039a0:	00000513          	li	a0,0
}
    802039a4:	02010113          	addi	sp,sp,32
    debugf("add task (pid=%d) to task queue", p->pid);
    802039a8:	00001317          	auipc	t1,0x1
    802039ac:	ba430067          	jr	-1116(t1) # 8020454c <dummy>
    asm volatile("mv %0, tp" : "=r"(x));
    802039b0:	00020493          	mv	s1,tp
    return r_tp();
    802039b4:	0004849b          	sext.w	s1,s1
    struct proc *p = curr_proc();
    802039b8:	00000097          	auipc	ra,0x0
    802039bc:	f28080e7          	jalr	-216(ra) # 802038e0 <curr_proc>
    return p ? p->pid : -1;
    802039c0:	06050263          	beqz	a0,80203a24 <add_task+0xd8>
    802039c4:	02452703          	lw	a4,36(a0)
    assert(p->state == RUNNABLE);
    802039c8:	00002897          	auipc	a7,0x2
    802039cc:	41888893          	addi	a7,a7,1048 # 80205de0 <e_text+0xde0>
    802039d0:	01800813          	li	a6,24
    assert(holding(&p->lock));
    802039d4:	00002797          	auipc	a5,0x2
    802039d8:	42478793          	addi	a5,a5,1060 # 80205df8 <e_text+0xdf8>
    802039dc:	00048693          	mv	a3,s1
    802039e0:	00001617          	auipc	a2,0x1
    802039e4:	64860613          	addi	a2,a2,1608 # 80205028 <e_text+0x28>
    802039e8:	01f00593          	li	a1,31
    802039ec:	00001517          	auipc	a0,0x1
    802039f0:	64450513          	addi	a0,a0,1604 # 80205030 <e_text+0x30>
    802039f4:	fffff097          	auipc	ra,0xfffff
    802039f8:	e90080e7          	jalr	-368(ra) # 80202884 <__panic>
    802039fc:	00020493          	mv	s1,tp
    80203a00:	0004849b          	sext.w	s1,s1
    struct proc *p = curr_proc();
    80203a04:	00000097          	auipc	ra,0x0
    80203a08:	edc080e7          	jalr	-292(ra) # 802038e0 <curr_proc>
    return p ? p->pid : -1;
    80203a0c:	02050063          	beqz	a0,80203a2c <add_task+0xe0>
    80203a10:	02452703          	lw	a4,36(a0)
    80203a14:	00002897          	auipc	a7,0x2
    80203a18:	30488893          	addi	a7,a7,772 # 80205d18 <e_text+0xd18>
    80203a1c:	01900813          	li	a6,25
    80203a20:	fb5ff06f          	j	802039d4 <add_task+0x88>
    80203a24:	fff00713          	li	a4,-1
    80203a28:	fa1ff06f          	j	802039c8 <add_task+0x7c>
    80203a2c:	fff00713          	li	a4,-1
    80203a30:	fe5ff06f          	j	80203a14 <add_task+0xc8>

0000000080203a34 <scheduler>:
void scheduler() {
    80203a34:	f8010113          	addi	sp,sp,-128
    80203a38:	06813823          	sd	s0,112(sp)
    80203a3c:	05313c23          	sd	s3,88(sp)
    80203a40:	05413823          	sd	s4,80(sp)
    80203a44:	05513423          	sd	s5,72(sp)
    80203a48:	05613023          	sd	s6,64(sp)
    80203a4c:	03813823          	sd	s8,48(sp)
    80203a50:	03913423          	sd	s9,40(sp)
    80203a54:	03a13023          	sd	s10,32(sp)
    80203a58:	01b13c23          	sd	s11,24(sp)
    80203a5c:	08010413          	addi	s0,sp,128
    80203a60:	06113c23          	sd	ra,120(sp)
    80203a64:	06913423          	sd	s1,104(sp)
    80203a68:	07213023          	sd	s2,96(sp)
    80203a6c:	03713c23          	sd	s7,56(sp)
    struct cpu *c = mycpu();
    80203a70:	00000097          	auipc	ra,0x0
    80203a74:	67c080e7          	jalr	1660(ra) # 802040ec <mycpu>
        c->proc  = p;
        swtch(&c->sched_context, &p->context);
    80203a78:	01050793          	addi	a5,a0,16
    struct cpu *c = mycpu();
    80203a7c:	00050a13          	mv	s4,a0
    struct proc *proc = pop_queue(&task_queue);
    80203a80:	00018b17          	auipc	s6,0x18
    80203a84:	618b0b13          	addi	s6,s6,1560 # 8021c098 <task_queue>
        assert(p->state == RUNNABLE);
    80203a88:	00300a93          	li	s5,3
        logf(PURPLE, "sched", "switch to proc pid(%d)", p->pid);
    80203a8c:	00003d97          	auipc	s11,0x3
    80203a90:	84cd8d93          	addi	s11,s11,-1972 # 802062d8 <__func__.1>
    80203a94:	00002d17          	auipc	s10,0x2
    80203a98:	3acd0d13          	addi	s10,s10,940 # 80205e40 <e_text+0xe40>
    80203a9c:	00002c97          	auipc	s9,0x2
    80203aa0:	3acc8c93          	addi	s9,s9,940 # 80205e48 <e_text+0xe48>
        p->state = RUNNING;
    80203aa4:	00400c13          	li	s8,4
        swtch(&c->sched_context, &p->context);
    80203aa8:	f8f43423          	sd	a5,-120(s0)
    80203aac:	00018997          	auipc	s3,0x18
    80203ab0:	5ec98993          	addi	s3,s3,1516 # 8021c098 <task_queue>
    struct proc *proc = pop_queue(&task_queue);
    80203ab4:	000b0513          	mv	a0,s6
    80203ab8:	00000097          	auipc	ra,0x0
    80203abc:	cd8080e7          	jalr	-808(ra) # 80203790 <pop_queue>
    80203ac0:	00050493          	mv	s1,a0
    if (proc != NULL)
    80203ac4:	0c050e63          	beqz	a0,80203ba0 <scheduler+0x16c>
        debugf("fetch task (pid=%d) from task queue", proc->pid);
    80203ac8:	02452583          	lw	a1,36(a0)
    80203acc:	00000513          	li	a0,0
    80203ad0:	00001097          	auipc	ra,0x1
    80203ad4:	a7c080e7          	jalr	-1412(ra) # 8020454c <dummy>
        acquire(&p->lock);
    80203ad8:	00048513          	mv	a0,s1
    80203adc:	ffffe097          	auipc	ra,0xffffe
    80203ae0:	020080e7          	jalr	32(ra) # 80201afc <acquire>
        assert(p->state == RUNNABLE);
    80203ae4:	0204a783          	lw	a5,32(s1)
    80203ae8:	17579e63          	bne	a5,s5,80203c64 <scheduler+0x230>
    80203aec:	00020693          	mv	a3,tp
    80203af0:	00068b9b          	sext.w	s7,a3
    push_off();
    80203af4:	ffffe097          	auipc	ra,0xffffe
    80203af8:	e70080e7          	jalr	-400(ra) # 80201964 <push_off>
    struct cpu* c = mycpu();
    80203afc:	00000097          	auipc	ra,0x0
    80203b00:	5f0080e7          	jalr	1520(ra) # 802040ec <mycpu>
    struct proc* p = c->proc;
    80203b04:	00853903          	ld	s2,8(a0)
    pop_off();
    80203b08:	ffffe097          	auipc	ra,0xffffe
    80203b0c:	ed0080e7          	jalr	-304(ra) # 802019d8 <pop_off>
    80203b10:	20090c63          	beqz	s2,80203d28 <scheduler+0x2f4>
    80203b14:	02492703          	lw	a4,36(s2)
        logf(PURPLE, "sched", "switch to proc pid(%d)", p->pid);
    80203b18:	0244a803          	lw	a6,36(s1)
    80203b1c:	000d8793          	mv	a5,s11
    80203b20:	000b8693          	mv	a3,s7
    80203b24:	000d0613          	mv	a2,s10
    80203b28:	02300593          	li	a1,35
    80203b2c:	000c8513          	mv	a0,s9
    80203b30:	fffff097          	auipc	ra,0xfffff
    80203b34:	054080e7          	jalr	84(ra) # 80202b84 <printf>
        swtch(&c->sched_context, &p->context);
    80203b38:	f8843503          	ld	a0,-120(s0)
        p->state = RUNNING;
    80203b3c:	0384a023          	sw	s8,32(s1)
        c->proc  = p;
    80203b40:	009a3423          	sd	s1,8(s4)
        swtch(&c->sched_context, &p->context);
    80203b44:	05848593          	addi	a1,s1,88
    80203b48:	00001097          	auipc	ra,0x1
    80203b4c:	120080e7          	jalr	288(ra) # 80204c68 <swtch>

        // When we get back here, someone must have called swtch(..., &c->sched_context);
        assert(c->proc == p);
    80203b50:	008a3783          	ld	a5,8(s4)
    80203b54:	18979263          	bne	a5,s1,80203cd8 <scheduler+0x2a4>
    asm volatile("csrr %0, sstatus" : "=r"(x));
    80203b58:	100027f3          	csrr	a5,sstatus
    return (x & SSTATUS_SIE) != 0;
    80203b5c:	0027f793          	andi	a5,a5,2
        assert(!intr_get());        // scheduler should never have intr_on()
    80203b60:	14079863          	bnez	a5,80203cb0 <scheduler+0x27c>
        assert(holding(&p->lock));  // whoever switch to us must acquire p->lock
    80203b64:	00048513          	mv	a0,s1
    80203b68:	ffffe097          	auipc	ra,0xffffe
    80203b6c:	db0080e7          	jalr	-592(ra) # 80201918 <holding>
    80203b70:	18050863          	beqz	a0,80203d00 <scheduler+0x2cc>
        c->proc = NULL;

        if (p->state == RUNNABLE) {
    80203b74:	0204a783          	lw	a5,32(s1)
        c->proc = NULL;
    80203b78:	000a3423          	sd	zero,8(s4)
        if (p->state == RUNNABLE) {
    80203b7c:	0d578c63          	beq	a5,s5,80203c54 <scheduler+0x220>
            add_task(p);
        }
        release(&p->lock);
    80203b80:	00048513          	mv	a0,s1
    80203b84:	ffffe097          	auipc	ra,0xffffe
    80203b88:	0bc080e7          	jalr	188(ra) # 80201c40 <release>
    struct proc *proc = pop_queue(&task_queue);
    80203b8c:	000b0513          	mv	a0,s6
    80203b90:	00000097          	auipc	ra,0x0
    80203b94:	c00080e7          	jalr	-1024(ra) # 80203790 <pop_queue>
    80203b98:	00050493          	mv	s1,a0
    if (proc != NULL)
    80203b9c:	f20516e3          	bnez	a0,80203ac8 <scheduler+0x94>
    push_off();
    80203ba0:	ffffe097          	auipc	ra,0xffffe
    80203ba4:	dc4080e7          	jalr	-572(ra) # 80201964 <push_off>
    for (int i = 0; i < NPROC; i++) {
    80203ba8:	00017917          	auipc	s2,0x17
    80203bac:	4f090913          	addi	s2,s2,1264 # 8021b098 <pool>
        struct proc *p = pool[i];
    80203bb0:	00093483          	ld	s1,0(s2)
        acquire(&p->lock);
    80203bb4:	00048513          	mv	a0,s1
    80203bb8:	ffffe097          	auipc	ra,0xffffe
    80203bbc:	f44080e7          	jalr	-188(ra) # 80201afc <acquire>
        if (p->state != UNUSED)
    80203bc0:	0204a783          	lw	a5,32(s1)
        release(&p->lock);
    80203bc4:	00048513          	mv	a0,s1
        if (p->state != UNUSED)
    80203bc8:	02078463          	beqz	a5,80203bf0 <scheduler+0x1bc>
        release(&p->lock);
    80203bcc:	ffffe097          	auipc	ra,0xffffe
    80203bd0:	074080e7          	jalr	116(ra) # 80201c40 <release>
    pop_off();
    80203bd4:	ffffe097          	auipc	ra,0xffffe
    80203bd8:	e04080e7          	jalr	-508(ra) # 802019d8 <pop_off>
    asm volatile("csrrs x0, sstatus, %0" ::"r"(SSTATUS_SIE));
    80203bdc:	00200793          	li	a5,2
    80203be0:	1007a073          	csrs	sstatus,a5
                asm volatile("wfi");
    80203be4:	10500073          	wfi
    asm volatile("csrrc %0, sstatus, %1" : "=r"(prev) : "r"(SSTATUS_SIE));
    80203be8:	1007b7f3          	csrrc	a5,sstatus,a5
                continue;
    80203bec:	ec9ff06f          	j	80203ab4 <scheduler+0x80>
    for (int i = 0; i < NPROC; i++) {
    80203bf0:	00890913          	addi	s2,s2,8
        release(&p->lock);
    80203bf4:	ffffe097          	auipc	ra,0xffffe
    80203bf8:	04c080e7          	jalr	76(ra) # 80201c40 <release>
    for (int i = 0; i < NPROC; i++) {
    80203bfc:	fb391ae3          	bne	s2,s3,80203bb0 <scheduler+0x17c>
    pop_off();
    80203c00:	ffffe097          	auipc	ra,0xffffe
    80203c04:	dd8080e7          	jalr	-552(ra) # 802019d8 <pop_off>
    asm volatile("mv %0, tp" : "=r"(x));
    80203c08:	00020693          	mv	a3,tp
    return r_tp();
    80203c0c:	0006869b          	sext.w	a3,a3
    80203c10:	f8d43423          	sd	a3,-120(s0)
    struct proc *p = curr_proc();
    80203c14:	00000097          	auipc	ra,0x0
    80203c18:	ccc080e7          	jalr	-820(ra) # 802038e0 <curr_proc>
    return p ? p->pid : -1;
    80203c1c:	f8843683          	ld	a3,-120(s0)
    80203c20:	10050863          	beqz	a0,80203d30 <scheduler+0x2fc>
    80203c24:	02452703          	lw	a4,36(a0)
                panic("[cpu %d] scheduler dead.", c->cpuid);
    80203c28:	098a2883          	lw	a7,152(s4)
    80203c2c:	04500813          	li	a6,69
    80203c30:	00002797          	auipc	a5,0x2
    80203c34:	1c878793          	addi	a5,a5,456 # 80205df8 <e_text+0xdf8>
    80203c38:	00001617          	auipc	a2,0x1
    80203c3c:	3f060613          	addi	a2,a2,1008 # 80205028 <e_text+0x28>
    80203c40:	01f00593          	li	a1,31
    80203c44:	00002517          	auipc	a0,0x2
    80203c48:	1c450513          	addi	a0,a0,452 # 80205e08 <e_text+0xe08>
    80203c4c:	fffff097          	auipc	ra,0xfffff
    80203c50:	c38080e7          	jalr	-968(ra) # 80202884 <__panic>
            add_task(p);
    80203c54:	00048513          	mv	a0,s1
    80203c58:	00000097          	auipc	ra,0x0
    80203c5c:	cf4080e7          	jalr	-780(ra) # 8020394c <add_task>
    80203c60:	f21ff06f          	j	80203b80 <scheduler+0x14c>
    80203c64:	00020493          	mv	s1,tp
    80203c68:	0004849b          	sext.w	s1,s1
    struct proc *p = curr_proc();
    80203c6c:	00000097          	auipc	ra,0x0
    80203c70:	c74080e7          	jalr	-908(ra) # 802038e0 <curr_proc>
    return p ? p->pid : -1;
    80203c74:	0c050e63          	beqz	a0,80203d50 <scheduler+0x31c>
    80203c78:	02452703          	lw	a4,36(a0)
        assert(p->state == RUNNABLE);
    80203c7c:	00002897          	auipc	a7,0x2
    80203c80:	16488893          	addi	a7,a7,356 # 80205de0 <e_text+0xde0>
    80203c84:	05000813          	li	a6,80
        assert(c->proc == p);
    80203c88:	00002797          	auipc	a5,0x2
    80203c8c:	17078793          	addi	a5,a5,368 # 80205df8 <e_text+0xdf8>
    80203c90:	00048693          	mv	a3,s1
    80203c94:	00001617          	auipc	a2,0x1
    80203c98:	39460613          	addi	a2,a2,916 # 80205028 <e_text+0x28>
    80203c9c:	01f00593          	li	a1,31
    80203ca0:	00001517          	auipc	a0,0x1
    80203ca4:	39050513          	addi	a0,a0,912 # 80205030 <e_text+0x30>
    80203ca8:	fffff097          	auipc	ra,0xfffff
    80203cac:	bdc080e7          	jalr	-1060(ra) # 80202884 <__panic>
    80203cb0:	00020493          	mv	s1,tp
    80203cb4:	0004849b          	sext.w	s1,s1
    struct proc *p = curr_proc();
    80203cb8:	00000097          	auipc	ra,0x0
    80203cbc:	c28080e7          	jalr	-984(ra) # 802038e0 <curr_proc>
    return p ? p->pid : -1;
    80203cc0:	08050463          	beqz	a0,80203d48 <scheduler+0x314>
    80203cc4:	02452703          	lw	a4,36(a0)
        assert(!intr_get());        // scheduler should never have intr_on()
    80203cc8:	00002897          	auipc	a7,0x2
    80203ccc:	1c088893          	addi	a7,a7,448 # 80205e88 <e_text+0xe88>
    80203cd0:	05800813          	li	a6,88
    80203cd4:	fb5ff06f          	j	80203c88 <scheduler+0x254>
    80203cd8:	00020493          	mv	s1,tp
    80203cdc:	0004849b          	sext.w	s1,s1
    struct proc *p = curr_proc();
    80203ce0:	00000097          	auipc	ra,0x0
    80203ce4:	c00080e7          	jalr	-1024(ra) # 802038e0 <curr_proc>
    return p ? p->pid : -1;
    80203ce8:	04050c63          	beqz	a0,80203d40 <scheduler+0x30c>
    80203cec:	02452703          	lw	a4,36(a0)
        assert(c->proc == p);
    80203cf0:	00002897          	auipc	a7,0x2
    80203cf4:	18888893          	addi	a7,a7,392 # 80205e78 <e_text+0xe78>
    80203cf8:	05700813          	li	a6,87
    80203cfc:	f8dff06f          	j	80203c88 <scheduler+0x254>
    80203d00:	00020493          	mv	s1,tp
    80203d04:	0004849b          	sext.w	s1,s1
    struct proc *p = curr_proc();
    80203d08:	00000097          	auipc	ra,0x0
    80203d0c:	bd8080e7          	jalr	-1064(ra) # 802038e0 <curr_proc>
    return p ? p->pid : -1;
    80203d10:	02050463          	beqz	a0,80203d38 <scheduler+0x304>
    80203d14:	02452703          	lw	a4,36(a0)
        assert(holding(&p->lock));  // whoever switch to us must acquire p->lock
    80203d18:	00002897          	auipc	a7,0x2
    80203d1c:	00088893          	mv	a7,a7
    80203d20:	05900813          	li	a6,89
    80203d24:	f65ff06f          	j	80203c88 <scheduler+0x254>
    80203d28:	fff00713          	li	a4,-1
    80203d2c:	dedff06f          	j	80203b18 <scheduler+0xe4>
    80203d30:	fff00713          	li	a4,-1
    80203d34:	ef5ff06f          	j	80203c28 <scheduler+0x1f4>
    80203d38:	fff00713          	li	a4,-1
    80203d3c:	fddff06f          	j	80203d18 <scheduler+0x2e4>
    80203d40:	fff00713          	li	a4,-1
    80203d44:	fadff06f          	j	80203cf0 <scheduler+0x2bc>
    80203d48:	fff00713          	li	a4,-1
    80203d4c:	f7dff06f          	j	80203cc8 <scheduler+0x294>
    80203d50:	fff00713          	li	a4,-1
    80203d54:	f29ff06f          	j	80203c7c <scheduler+0x248>

0000000080203d58 <sched>:
// intena because intena is a property of this
// kernel thread, not this CPU. It should
// be proc->intena and proc->noff, but that would
// break in the few places where a lock is held but
// there's no process.
void sched() {
    80203d58:	fd010113          	addi	sp,sp,-48
    80203d5c:	02113423          	sd	ra,40(sp)
    80203d60:	02813023          	sd	s0,32(sp)
    80203d64:	00913c23          	sd	s1,24(sp)
    80203d68:	03010413          	addi	s0,sp,48
    80203d6c:	01213823          	sd	s2,16(sp)
    80203d70:	01313423          	sd	s3,8(sp)
    80203d74:	01413023          	sd	s4,0(sp)
    push_off();
    80203d78:	ffffe097          	auipc	ra,0xffffe
    80203d7c:	bec080e7          	jalr	-1044(ra) # 80201964 <push_off>
    struct cpu* c = mycpu();
    80203d80:	00000097          	auipc	ra,0x0
    80203d84:	36c080e7          	jalr	876(ra) # 802040ec <mycpu>
    struct proc* p = c->proc;
    80203d88:	00853483          	ld	s1,8(a0)
    pop_off();
    80203d8c:	ffffe097          	auipc	ra,0xffffe
    80203d90:	c4c080e7          	jalr	-948(ra) # 802019d8 <pop_off>
    int interrupt_on;
    struct proc *p = curr_proc();

    if (!holding(&p->lock))
    80203d94:	00048513          	mv	a0,s1
    80203d98:	ffffe097          	auipc	ra,0xffffe
    80203d9c:	b80080e7          	jalr	-1152(ra) # 80201918 <holding>
    80203da0:	1c050a63          	beqz	a0,80203f74 <sched+0x21c>
        panic("not holding p->lock");
    if (mycpu()->noff != 1)
    80203da4:	00000097          	auipc	ra,0x0
    80203da8:	348080e7          	jalr	840(ra) # 802040ec <mycpu>
    80203dac:	08452703          	lw	a4,132(a0)
    80203db0:	00100793          	li	a5,1
    80203db4:	20f71263          	bne	a4,a5,80203fb8 <sched+0x260>
        panic("holding another locks");
    if (p->state == RUNNING)
    80203db8:	0204a703          	lw	a4,32(s1)
    80203dbc:	00400793          	li	a5,4
    80203dc0:	16f70863          	beq	a4,a5,80203f30 <sched+0x1d8>
        panic("sched running process");
    if (mycpu()->inkernel_trap)
    80203dc4:	00000097          	auipc	ra,0x0
    80203dc8:	328080e7          	jalr	808(ra) # 802040ec <mycpu>
    80203dcc:	08052783          	lw	a5,128(a0)
    80203dd0:	10079e63          	bnez	a5,80203eec <sched+0x194>
    asm volatile("csrr %0, sstatus" : "=r"(x));
    80203dd4:	100027f3          	csrr	a5,sstatus
    return (x & SSTATUS_SIE) != 0;
    80203dd8:	0027f793          	andi	a5,a5,2
        panic("sched should never be called in kernel trap context.");
    assert(!intr_get());
    80203ddc:	0c079263          	bnez	a5,80203ea0 <sched+0x148>

    interrupt_on = mycpu()->interrupt_on;
    80203de0:	00000097          	auipc	ra,0x0
    80203de4:	30c080e7          	jalr	780(ra) # 802040ec <mycpu>
    80203de8:	08852a03          	lw	s4,136(a0)
    asm volatile("mv %0, tp" : "=r"(x));
    80203dec:	00020913          	mv	s2,tp
    push_off();
    80203df0:	ffffe097          	auipc	ra,0xffffe
    80203df4:	b74080e7          	jalr	-1164(ra) # 80201964 <push_off>
    struct cpu* c = mycpu();
    80203df8:	00000097          	auipc	ra,0x0
    80203dfc:	2f4080e7          	jalr	756(ra) # 802040ec <mycpu>
    struct proc* p = c->proc;
    80203e00:	00853983          	ld	s3,8(a0)
    return r_tp();
    80203e04:	0009091b          	sext.w	s2,s2
    pop_off();
    80203e08:	ffffe097          	auipc	ra,0xffffe
    80203e0c:	bd0080e7          	jalr	-1072(ra) # 802019d8 <pop_off>
    80203e10:	08098463          	beqz	s3,80203e98 <sched+0x140>
    80203e14:	0249a703          	lw	a4,36(s3)
    logf(PURPLE, "sched", "switch to scheduler pid(%d)", p->pid);
    80203e18:	0244a803          	lw	a6,36(s1)
    80203e1c:	00002797          	auipc	a5,0x2
    80203e20:	53c78793          	addi	a5,a5,1340 # 80206358 <__func__.0>
    80203e24:	00090693          	mv	a3,s2
    80203e28:	00002617          	auipc	a2,0x2
    80203e2c:	01860613          	addi	a2,a2,24 # 80205e40 <e_text+0xe40>
    80203e30:	02300593          	li	a1,35
    80203e34:	00002517          	auipc	a0,0x2
    80203e38:	15c50513          	addi	a0,a0,348 # 80205f90 <e_text+0xf90>
    80203e3c:	fffff097          	auipc	ra,0xfffff
    80203e40:	d48080e7          	jalr	-696(ra) # 80202b84 <printf>
    swtch(&p->context, &mycpu()->sched_context);
    80203e44:	00000097          	auipc	ra,0x0
    80203e48:	2a8080e7          	jalr	680(ra) # 802040ec <mycpu>
    80203e4c:	01050593          	addi	a1,a0,16
    80203e50:	05848513          	addi	a0,s1,88
    80203e54:	00001097          	auipc	ra,0x1
    80203e58:	e14080e7          	jalr	-492(ra) # 80204c68 <swtch>
    mycpu()->interrupt_on = interrupt_on;
    80203e5c:	00000097          	auipc	ra,0x0
    80203e60:	290080e7          	jalr	656(ra) # 802040ec <mycpu>
    80203e64:	09452423          	sw	s4,136(a0)

    // if scheduler returns here: p->lock must be holding.
    if (!holding(&p->lock))
    80203e68:	00048513          	mv	a0,s1
    80203e6c:	ffffe097          	auipc	ra,0xffffe
    80203e70:	aac080e7          	jalr	-1364(ra) # 80201918 <holding>
    80203e74:	18050463          	beqz	a0,80203ffc <sched+0x2a4>
        panic("not holding p->lock after sched.swtch returns");
}
    80203e78:	02813083          	ld	ra,40(sp)
    80203e7c:	02013403          	ld	s0,32(sp)
    80203e80:	01813483          	ld	s1,24(sp)
    80203e84:	01013903          	ld	s2,16(sp)
    80203e88:	00813983          	ld	s3,8(sp)
    80203e8c:	00013a03          	ld	s4,0(sp)
    80203e90:	03010113          	addi	sp,sp,48
    80203e94:	00008067          	ret
    80203e98:	fff00713          	li	a4,-1
    80203e9c:	f7dff06f          	j	80203e18 <sched+0xc0>
    80203ea0:	00020493          	mv	s1,tp
    return r_tp();
    80203ea4:	0004849b          	sext.w	s1,s1
    struct proc *p = curr_proc();
    80203ea8:	00000097          	auipc	ra,0x0
    80203eac:	a38080e7          	jalr	-1480(ra) # 802038e0 <curr_proc>
    return p ? p->pid : -1;
    80203eb0:	18050863          	beqz	a0,80204040 <sched+0x2e8>
    80203eb4:	02452703          	lw	a4,36(a0)
    assert(!intr_get());
    80203eb8:	00002897          	auipc	a7,0x2
    80203ebc:	fd088893          	addi	a7,a7,-48 # 80205e88 <e_text+0xe88>
    80203ec0:	07600813          	li	a6,118
    80203ec4:	00002797          	auipc	a5,0x2
    80203ec8:	f3478793          	addi	a5,a5,-204 # 80205df8 <e_text+0xdf8>
    80203ecc:	00048693          	mv	a3,s1
    80203ed0:	00001617          	auipc	a2,0x1
    80203ed4:	15860613          	addi	a2,a2,344 # 80205028 <e_text+0x28>
    80203ed8:	01f00593          	li	a1,31
    80203edc:	00001517          	auipc	a0,0x1
    80203ee0:	15450513          	addi	a0,a0,340 # 80205030 <e_text+0x30>
    80203ee4:	fffff097          	auipc	ra,0xfffff
    80203ee8:	9a0080e7          	jalr	-1632(ra) # 80202884 <__panic>
    80203eec:	00020493          	mv	s1,tp
    80203ef0:	0004849b          	sext.w	s1,s1
    struct proc *p = curr_proc();
    80203ef4:	00000097          	auipc	ra,0x0
    80203ef8:	9ec080e7          	jalr	-1556(ra) # 802038e0 <curr_proc>
    return p ? p->pid : -1;
    80203efc:	14050a63          	beqz	a0,80204050 <sched+0x2f8>
    80203f00:	02452703          	lw	a4,36(a0)
        panic("sched should never be called in kernel trap context.");
    80203f04:	07500813          	li	a6,117
    80203f08:	00002797          	auipc	a5,0x2
    80203f0c:	ef078793          	addi	a5,a5,-272 # 80205df8 <e_text+0xdf8>
    80203f10:	00048693          	mv	a3,s1
    80203f14:	00001617          	auipc	a2,0x1
    80203f18:	11460613          	addi	a2,a2,276 # 80205028 <e_text+0x28>
    80203f1c:	01f00593          	li	a1,31
    80203f20:	00002517          	auipc	a0,0x2
    80203f24:	01850513          	addi	a0,a0,24 # 80205f38 <e_text+0xf38>
    80203f28:	fffff097          	auipc	ra,0xfffff
    80203f2c:	95c080e7          	jalr	-1700(ra) # 80202884 <__panic>
    80203f30:	00020493          	mv	s1,tp
    80203f34:	0004849b          	sext.w	s1,s1
    struct proc *p = curr_proc();
    80203f38:	00000097          	auipc	ra,0x0
    80203f3c:	9a8080e7          	jalr	-1624(ra) # 802038e0 <curr_proc>
    return p ? p->pid : -1;
    80203f40:	12050063          	beqz	a0,80204060 <sched+0x308>
    80203f44:	02452703          	lw	a4,36(a0)
        panic("sched running process");
    80203f48:	07300813          	li	a6,115
    80203f4c:	00002797          	auipc	a5,0x2
    80203f50:	eac78793          	addi	a5,a5,-340 # 80205df8 <e_text+0xdf8>
    80203f54:	00048693          	mv	a3,s1
    80203f58:	00001617          	auipc	a2,0x1
    80203f5c:	0d060613          	addi	a2,a2,208 # 80205028 <e_text+0x28>
    80203f60:	01f00593          	li	a1,31
    80203f64:	00002517          	auipc	a0,0x2
    80203f68:	f9c50513          	addi	a0,a0,-100 # 80205f00 <e_text+0xf00>
    80203f6c:	fffff097          	auipc	ra,0xfffff
    80203f70:	918080e7          	jalr	-1768(ra) # 80202884 <__panic>
    80203f74:	00020493          	mv	s1,tp
    80203f78:	0004849b          	sext.w	s1,s1
    struct proc *p = curr_proc();
    80203f7c:	00000097          	auipc	ra,0x0
    80203f80:	964080e7          	jalr	-1692(ra) # 802038e0 <curr_proc>
    return p ? p->pid : -1;
    80203f84:	0c050a63          	beqz	a0,80204058 <sched+0x300>
    80203f88:	02452703          	lw	a4,36(a0)
        panic("not holding p->lock");
    80203f8c:	06f00813          	li	a6,111
    80203f90:	00002797          	auipc	a5,0x2
    80203f94:	e6878793          	addi	a5,a5,-408 # 80205df8 <e_text+0xdf8>
    80203f98:	00048693          	mv	a3,s1
    80203f9c:	00001617          	auipc	a2,0x1
    80203fa0:	08c60613          	addi	a2,a2,140 # 80205028 <e_text+0x28>
    80203fa4:	01f00593          	li	a1,31
    80203fa8:	00002517          	auipc	a0,0x2
    80203fac:	ef050513          	addi	a0,a0,-272 # 80205e98 <e_text+0xe98>
    80203fb0:	fffff097          	auipc	ra,0xfffff
    80203fb4:	8d4080e7          	jalr	-1836(ra) # 80202884 <__panic>
    80203fb8:	00020493          	mv	s1,tp
    80203fbc:	0004849b          	sext.w	s1,s1
    struct proc *p = curr_proc();
    80203fc0:	00000097          	auipc	ra,0x0
    80203fc4:	920080e7          	jalr	-1760(ra) # 802038e0 <curr_proc>
    return p ? p->pid : -1;
    80203fc8:	0a050063          	beqz	a0,80204068 <sched+0x310>
    80203fcc:	02452703          	lw	a4,36(a0)
        panic("holding another locks");
    80203fd0:	07100813          	li	a6,113
    80203fd4:	00002797          	auipc	a5,0x2
    80203fd8:	e2478793          	addi	a5,a5,-476 # 80205df8 <e_text+0xdf8>
    80203fdc:	00048693          	mv	a3,s1
    80203fe0:	00001617          	auipc	a2,0x1
    80203fe4:	04860613          	addi	a2,a2,72 # 80205028 <e_text+0x28>
    80203fe8:	01f00593          	li	a1,31
    80203fec:	00002517          	auipc	a0,0x2
    80203ff0:	edc50513          	addi	a0,a0,-292 # 80205ec8 <e_text+0xec8>
    80203ff4:	fffff097          	auipc	ra,0xfffff
    80203ff8:	890080e7          	jalr	-1904(ra) # 80202884 <__panic>
    80203ffc:	00020493          	mv	s1,tp
    80204000:	0004849b          	sext.w	s1,s1
    struct proc *p = curr_proc();
    80204004:	00000097          	auipc	ra,0x0
    80204008:	8dc080e7          	jalr	-1828(ra) # 802038e0 <curr_proc>
    return p ? p->pid : -1;
    8020400c:	02050e63          	beqz	a0,80204048 <sched+0x2f0>
    80204010:	02452703          	lw	a4,36(a0)
        panic("not holding p->lock after sched.swtch returns");
    80204014:	07f00813          	li	a6,127
    80204018:	00002797          	auipc	a5,0x2
    8020401c:	de078793          	addi	a5,a5,-544 # 80205df8 <e_text+0xdf8>
    80204020:	00048693          	mv	a3,s1
    80204024:	00001617          	auipc	a2,0x1
    80204028:	00460613          	addi	a2,a2,4 # 80205028 <e_text+0x28>
    8020402c:	01f00593          	li	a1,31
    80204030:	00002517          	auipc	a0,0x2
    80204034:	f9850513          	addi	a0,a0,-104 # 80205fc8 <e_text+0xfc8>
    80204038:	fffff097          	auipc	ra,0xfffff
    8020403c:	84c080e7          	jalr	-1972(ra) # 80202884 <__panic>
    80204040:	fff00713          	li	a4,-1
    80204044:	e75ff06f          	j	80203eb8 <sched+0x160>
    80204048:	fff00713          	li	a4,-1
    8020404c:	fc9ff06f          	j	80204014 <sched+0x2bc>
    80204050:	fff00713          	li	a4,-1
    80204054:	eb1ff06f          	j	80203f04 <sched+0x1ac>
    80204058:	fff00713          	li	a4,-1
    8020405c:	f31ff06f          	j	80203f8c <sched+0x234>
    80204060:	fff00713          	li	a4,-1
    80204064:	ee5ff06f          	j	80203f48 <sched+0x1f0>
    80204068:	fff00713          	li	a4,-1
    8020406c:	f65ff06f          	j	80203fd0 <sched+0x278>

0000000080204070 <yield>:

// Give up the CPU for one scheduling round.
void yield() {
    80204070:	fe010113          	addi	sp,sp,-32
    80204074:	00113c23          	sd	ra,24(sp)
    80204078:	00813823          	sd	s0,16(sp)
    8020407c:	00913423          	sd	s1,8(sp)
    80204080:	02010413          	addi	s0,sp,32
    push_off();
    80204084:	ffffe097          	auipc	ra,0xffffe
    80204088:	8e0080e7          	jalr	-1824(ra) # 80201964 <push_off>
    struct cpu* c = mycpu();
    8020408c:	00000097          	auipc	ra,0x0
    80204090:	060080e7          	jalr	96(ra) # 802040ec <mycpu>
    struct proc* p = c->proc;
    80204094:	00853483          	ld	s1,8(a0)
    pop_off();
    80204098:	ffffe097          	auipc	ra,0xffffe
    8020409c:	940080e7          	jalr	-1728(ra) # 802019d8 <pop_off>
    struct proc *p = curr_proc();
    debugf("yield: (%d)%p", p->pid, p);
    802040a0:	00000513          	li	a0,0
    802040a4:	0244a583          	lw	a1,36(s1)
    802040a8:	00048613          	mv	a2,s1
    802040ac:	00000097          	auipc	ra,0x0
    802040b0:	4a0080e7          	jalr	1184(ra) # 8020454c <dummy>

    acquire(&p->lock);
    802040b4:	00048513          	mv	a0,s1
    802040b8:	ffffe097          	auipc	ra,0xffffe
    802040bc:	a44080e7          	jalr	-1468(ra) # 80201afc <acquire>
    p->state = RUNNABLE;
    802040c0:	00300793          	li	a5,3
    802040c4:	02f4a023          	sw	a5,32(s1)
    sched();
    802040c8:	00000097          	auipc	ra,0x0
    802040cc:	c90080e7          	jalr	-880(ra) # 80203d58 <sched>
    release(&p->lock);
}
    802040d0:	01013403          	ld	s0,16(sp)
    802040d4:	01813083          	ld	ra,24(sp)
    release(&p->lock);
    802040d8:	00048513          	mv	a0,s1
}
    802040dc:	00813483          	ld	s1,8(sp)
    802040e0:	02010113          	addi	sp,sp,32
    release(&p->lock);
    802040e4:	ffffe317          	auipc	t1,0xffffe
    802040e8:	b5c30067          	jr	-1188(t1) # 80201c40 <release>

00000000802040ec <mycpu>:
#include "proc.h"
#include "string.h"

static struct cpu cpus[NCPU];

struct cpu* mycpu() {
    802040ec:	fe010113          	addi	sp,sp,-32
    802040f0:	00813823          	sd	s0,16(sp)
    802040f4:	00113c23          	sd	ra,24(sp)
    802040f8:	02010413          	addi	s0,sp,32
    asm volatile("csrr %0, sstatus" : "=r"(x));
    802040fc:	100027f3          	csrr	a5,sstatus
    return (x & SSTATUS_SIE) != 0;
    80204100:	0027f793          	andi	a5,a5,2
    assert(!intr_get());
    80204104:	02079e63          	bnez	a5,80204140 <mycpu+0x54>
    asm volatile("mv %0, tp" : "=r"(x));
    80204108:	00020713          	mv	a4,tp
    int id = cpuid();
    assert(id >= 0 && id < NCPU);
    8020410c:	00300793          	li	a5,3
    return r_tp();
    80204110:	0007071b          	sext.w	a4,a4
    80204114:	08e7ea63          	bltu	a5,a4,802041a8 <mycpu+0xbc>
    return &cpus[id];
}
    80204118:	01813083          	ld	ra,24(sp)
    8020411c:	01013403          	ld	s0,16(sp)
    return &cpus[id];
    80204120:	00271793          	slli	a5,a4,0x2
    80204124:	00e787b3          	add	a5,a5,a4
    80204128:	00579793          	slli	a5,a5,0x5
}
    8020412c:	0001a517          	auipc	a0,0x1a
    80204130:	f9c50513          	addi	a0,a0,-100 # 8021e0c8 <cpus>
    80204134:	00f50533          	add	a0,a0,a5
    80204138:	02010113          	addi	sp,sp,32
    8020413c:	00008067          	ret
    80204140:	00913423          	sd	s1,8(sp)
    80204144:	01213023          	sd	s2,0(sp)
    80204148:	00020693          	mv	a3,tp
    8020414c:	0006891b          	sext.w	s2,a3
    push_off();
    80204150:	ffffe097          	auipc	ra,0xffffe
    80204154:	814080e7          	jalr	-2028(ra) # 80201964 <push_off>
    struct cpu* c = mycpu();
    80204158:	00000097          	auipc	ra,0x0
    8020415c:	f94080e7          	jalr	-108(ra) # 802040ec <mycpu>
    struct proc* p = c->proc;
    80204160:	00853483          	ld	s1,8(a0)
    pop_off();
    80204164:	ffffe097          	auipc	ra,0xffffe
    80204168:	874080e7          	jalr	-1932(ra) # 802019d8 <pop_off>
    8020416c:	08048063          	beqz	s1,802041ec <mycpu+0x100>
    80204170:	0244a703          	lw	a4,36(s1)
    assert(!intr_get());
    80204174:	00002897          	auipc	a7,0x2
    80204178:	d1488893          	addi	a7,a7,-748 # 80205e88 <e_text+0xe88>
    8020417c:	00900813          	li	a6,9
    assert(id >= 0 && id < NCPU);
    80204180:	00002797          	auipc	a5,0x2
    80204184:	e9878793          	addi	a5,a5,-360 # 80206018 <e_text+0x1018>
    80204188:	00090693          	mv	a3,s2
    8020418c:	00001617          	auipc	a2,0x1
    80204190:	e9c60613          	addi	a2,a2,-356 # 80205028 <e_text+0x28>
    80204194:	01f00593          	li	a1,31
    80204198:	00001517          	auipc	a0,0x1
    8020419c:	e9850513          	addi	a0,a0,-360 # 80205030 <e_text+0x30>
    802041a0:	ffffe097          	auipc	ra,0xffffe
    802041a4:	6e4080e7          	jalr	1764(ra) # 80202884 <__panic>
    802041a8:	00913423          	sd	s1,8(sp)
    802041ac:	01213023          	sd	s2,0(sp)
    802041b0:	00020693          	mv	a3,tp
    return r_tp();
    802041b4:	0006891b          	sext.w	s2,a3
    push_off();
    802041b8:	ffffd097          	auipc	ra,0xffffd
    802041bc:	7ac080e7          	jalr	1964(ra) # 80201964 <push_off>
    struct cpu* c = mycpu();
    802041c0:	00000097          	auipc	ra,0x0
    802041c4:	f2c080e7          	jalr	-212(ra) # 802040ec <mycpu>
    struct proc* p = c->proc;
    802041c8:	00853483          	ld	s1,8(a0)
    pop_off();
    802041cc:	ffffe097          	auipc	ra,0xffffe
    802041d0:	80c080e7          	jalr	-2036(ra) # 802019d8 <pop_off>
    802041d4:	02048063          	beqz	s1,802041f4 <mycpu+0x108>
    802041d8:	0244a703          	lw	a4,36(s1)
    802041dc:	00002897          	auipc	a7,0x2
    802041e0:	e4c88893          	addi	a7,a7,-436 # 80206028 <e_text+0x1028>
    802041e4:	00b00813          	li	a6,11
    802041e8:	f99ff06f          	j	80204180 <mycpu+0x94>
    802041ec:	fff00713          	li	a4,-1
    802041f0:	f85ff06f          	j	80204174 <mycpu+0x88>
    802041f4:	fff00713          	li	a4,-1
    802041f8:	fe5ff06f          	j	802041dc <mycpu+0xf0>

00000000802041fc <getcpu>:

struct cpu* getcpu(int i) {
    assert(i >= 0 && i < NCPU);
    802041fc:	00300793          	li	a5,3
    80204200:	02a7e063          	bltu	a5,a0,80204220 <getcpu+0x24>
    return &cpus[i];
    80204204:	00251793          	slli	a5,a0,0x2
    80204208:	00a787b3          	add	a5,a5,a0
    8020420c:	00579793          	slli	a5,a5,0x5
    80204210:	0001a517          	auipc	a0,0x1a
    80204214:	eb850513          	addi	a0,a0,-328 # 8021e0c8 <cpus>
    80204218:	00f50533          	add	a0,a0,a5
    8020421c:	00008067          	ret
struct cpu* getcpu(int i) {
    80204220:	fe010113          	addi	sp,sp,-32
    80204224:	00813823          	sd	s0,16(sp)
    80204228:	00113c23          	sd	ra,24(sp)
    8020422c:	00913423          	sd	s1,8(sp)
    80204230:	01213023          	sd	s2,0(sp)
    80204234:	02010413          	addi	s0,sp,32
    80204238:	00020693          	mv	a3,tp
    return r_tp();
    8020423c:	0006891b          	sext.w	s2,a3
    push_off();
    80204240:	ffffd097          	auipc	ra,0xffffd
    80204244:	724080e7          	jalr	1828(ra) # 80201964 <push_off>
    struct cpu* c = mycpu();
    80204248:	00000097          	auipc	ra,0x0
    8020424c:	ea4080e7          	jalr	-348(ra) # 802040ec <mycpu>
    struct proc* p = c->proc;
    80204250:	00853483          	ld	s1,8(a0)
    pop_off();
    80204254:	ffffd097          	auipc	ra,0xffffd
    80204258:	784080e7          	jalr	1924(ra) # 802019d8 <pop_off>
    8020425c:	02048e63          	beqz	s1,80204298 <getcpu+0x9c>
    80204260:	0244a703          	lw	a4,36(s1)
    assert(i >= 0 && i < NCPU);
    80204264:	00002897          	auipc	a7,0x2
    80204268:	ddc88893          	addi	a7,a7,-548 # 80206040 <e_text+0x1040>
    8020426c:	01000813          	li	a6,16
    80204270:	00002797          	auipc	a5,0x2
    80204274:	da878793          	addi	a5,a5,-600 # 80206018 <e_text+0x1018>
    80204278:	00090693          	mv	a3,s2
    8020427c:	00001617          	auipc	a2,0x1
    80204280:	dac60613          	addi	a2,a2,-596 # 80205028 <e_text+0x28>
    80204284:	01f00593          	li	a1,31
    80204288:	00001517          	auipc	a0,0x1
    8020428c:	da850513          	addi	a0,a0,-600 # 80205030 <e_text+0x30>
    80204290:	ffffe097          	auipc	ra,0xffffe
    80204294:	5f4080e7          	jalr	1524(ra) # 80202884 <__panic>
    80204298:	fff00713          	li	a4,-1
    8020429c:	fc9ff06f          	j	80204264 <getcpu+0x68>

00000000802042a0 <memset>:
#include "string.h"
#include "types.h"

void *memset(void *dst, int c, uint n)
{
    802042a0:	ff010113          	addi	sp,sp,-16
    802042a4:	00813423          	sd	s0,8(sp)
    802042a8:	01010413          	addi	s0,sp,16
	char *cdst = (char *)dst;
	int i;
	for (i = 0; i < n; i++) {
    802042ac:	02060263          	beqz	a2,802042d0 <memset+0x30>
    802042b0:	02061613          	slli	a2,a2,0x20
    802042b4:	02065613          	srli	a2,a2,0x20
		cdst[i] = c;
    802042b8:	0ff5f593          	zext.b	a1,a1
    802042bc:	00050793          	mv	a5,a0
    802042c0:	00a60733          	add	a4,a2,a0
    802042c4:	00b78023          	sb	a1,0(a5)
	for (i = 0; i < n; i++) {
    802042c8:	00178793          	addi	a5,a5,1
    802042cc:	fee79ce3          	bne	a5,a4,802042c4 <memset+0x24>
	}
	return dst;
}
    802042d0:	00813403          	ld	s0,8(sp)
    802042d4:	01010113          	addi	sp,sp,16
    802042d8:	00008067          	ret

00000000802042dc <memcmp>:

int memcmp(const void *v1, const void *v2, uint n)
{
    802042dc:	ff010113          	addi	sp,sp,-16
    802042e0:	00813423          	sd	s0,8(sp)
    802042e4:	01010413          	addi	s0,sp,16
	const uchar *s1, *s2;

	s1 = v1;
	s2 = v2;
	while (n-- > 0) {
    802042e8:	04060263          	beqz	a2,8020432c <memcmp+0x50>
    802042ec:	fff6069b          	addiw	a3,a2,-1
    802042f0:	02069693          	slli	a3,a3,0x20
    802042f4:	0206d693          	srli	a3,a3,0x20
    802042f8:	00168693          	addi	a3,a3,1
    802042fc:	00d506b3          	add	a3,a0,a3
    80204300:	0080006f          	j	80204308 <memcmp+0x2c>
    80204304:	02a68463          	beq	a3,a0,8020432c <memcmp+0x50>
		if (*s1 != *s2)
    80204308:	00054783          	lbu	a5,0(a0)
    8020430c:	0005c703          	lbu	a4,0(a1)
			return *s1 - *s2;
		s1++, s2++;
    80204310:	00150513          	addi	a0,a0,1
    80204314:	00158593          	addi	a1,a1,1
		if (*s1 != *s2)
    80204318:	fee786e3          	beq	a5,a4,80204304 <memcmp+0x28>
	}

	return 0;
}
    8020431c:	00813403          	ld	s0,8(sp)
			return *s1 - *s2;
    80204320:	40e7853b          	subw	a0,a5,a4
}
    80204324:	01010113          	addi	sp,sp,16
    80204328:	00008067          	ret
    8020432c:	00813403          	ld	s0,8(sp)
	return 0;
    80204330:	00000513          	li	a0,0
}
    80204334:	01010113          	addi	sp,sp,16
    80204338:	00008067          	ret

000000008020433c <memmove>:

void *memmove(void *dst, const void *src, uint n)
{
    8020433c:	ff010113          	addi	sp,sp,-16
    80204340:	00813423          	sd	s0,8(sp)
    80204344:	01010413          	addi	s0,sp,16
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
    80204348:	fff6071b          	addiw	a4,a2,-1
	if (s < d && s + n > d) {
    8020434c:	04a5f663          	bgeu	a1,a0,80204398 <memmove+0x5c>
    80204350:	02061793          	slli	a5,a2,0x20
    80204354:	0207d793          	srli	a5,a5,0x20
    80204358:	00f586b3          	add	a3,a1,a5
    8020435c:	02d57e63          	bgeu	a0,a3,80204398 <memmove+0x5c>
		d += n;
    80204360:	00f505b3          	add	a1,a0,a5
		while (n-- > 0)
    80204364:	02060463          	beqz	a2,8020438c <memmove+0x50>
    80204368:	02071793          	slli	a5,a4,0x20
    8020436c:	0207d793          	srli	a5,a5,0x20
    80204370:	fff7c793          	not	a5,a5
    80204374:	00f687b3          	add	a5,a3,a5
			*--d = *--s;
    80204378:	fff6c703          	lbu	a4,-1(a3)
    8020437c:	fff68693          	addi	a3,a3,-1
    80204380:	fff58593          	addi	a1,a1,-1
    80204384:	00e58023          	sb	a4,0(a1)
		while (n-- > 0)
    80204388:	fef698e3          	bne	a3,a5,80204378 <memmove+0x3c>
	} else
		while (n-- > 0)
			*d++ = *s++;

	return dst;
}
    8020438c:	00813403          	ld	s0,8(sp)
    80204390:	01010113          	addi	sp,sp,16
    80204394:	00008067          	ret
		while (n-- > 0)
    80204398:	fe060ae3          	beqz	a2,8020438c <memmove+0x50>
    8020439c:	02071713          	slli	a4,a4,0x20
    802043a0:	02075713          	srli	a4,a4,0x20
    802043a4:	00170713          	addi	a4,a4,1
    802043a8:	00e58733          	add	a4,a1,a4
    802043ac:	00050793          	mv	a5,a0
			*d++ = *s++;
    802043b0:	0005c683          	lbu	a3,0(a1)
    802043b4:	00158593          	addi	a1,a1,1
    802043b8:	00178793          	addi	a5,a5,1
    802043bc:	fed78fa3          	sb	a3,-1(a5)
		while (n-- > 0)
    802043c0:	feb718e3          	bne	a4,a1,802043b0 <memmove+0x74>
}
    802043c4:	00813403          	ld	s0,8(sp)
    802043c8:	01010113          	addi	sp,sp,16
    802043cc:	00008067          	ret

00000000802043d0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void *memcpy(void *dst, const void *src, uint n)
{
    802043d0:	ff010113          	addi	sp,sp,-16
    802043d4:	00813423          	sd	s0,8(sp)
    802043d8:	01010413          	addi	s0,sp,16
	return memmove(dst, src, n);
}
    802043dc:	00813403          	ld	s0,8(sp)
    802043e0:	01010113          	addi	sp,sp,16
	return memmove(dst, src, n);
    802043e4:	00000317          	auipc	t1,0x0
    802043e8:	f5830067          	jr	-168(t1) # 8020433c <memmove>

00000000802043ec <strncmp>:

int strncmp(const char *p, const char *q, uint n)
{
    802043ec:	ff010113          	addi	sp,sp,-16
    802043f0:	00813423          	sd	s0,8(sp)
    802043f4:	01010413          	addi	s0,sp,16
	while (n > 0 && *p && *p == *q)
    802043f8:	00061e63          	bnez	a2,80204414 <strncmp+0x28>
    802043fc:	03c0006f          	j	80204438 <strncmp+0x4c>
    80204400:	0005c703          	lbu	a4,0(a1)
    80204404:	00f71e63          	bne	a4,a5,80204420 <strncmp+0x34>
		n--, p++, q++;
    80204408:	00150513          	addi	a0,a0,1
    8020440c:	00158593          	addi	a1,a1,1
	while (n > 0 && *p && *p == *q)
    80204410:	02060463          	beqz	a2,80204438 <strncmp+0x4c>
    80204414:	00054783          	lbu	a5,0(a0)
		n--, p++, q++;
    80204418:	fff6061b          	addiw	a2,a2,-1
	while (n > 0 && *p && *p == *q)
    8020441c:	fe0792e3          	bnez	a5,80204400 <strncmp+0x14>
	if (n == 0)
		return 0;
	return (uchar)*p - (uchar)*q;
    80204420:	00054503          	lbu	a0,0(a0)
    80204424:	0005c783          	lbu	a5,0(a1)
}
    80204428:	00813403          	ld	s0,8(sp)
	return (uchar)*p - (uchar)*q;
    8020442c:	40f5053b          	subw	a0,a0,a5
}
    80204430:	01010113          	addi	sp,sp,16
    80204434:	00008067          	ret
    80204438:	00813403          	ld	s0,8(sp)
		return 0;
    8020443c:	00000513          	li	a0,0
}
    80204440:	01010113          	addi	sp,sp,16
    80204444:	00008067          	ret

0000000080204448 <strncpy>:

char *strncpy(char *s, const char *t, int n)
{
    80204448:	ff010113          	addi	sp,sp,-16
    8020444c:	00813423          	sd	s0,8(sp)
    80204450:	01010413          	addi	s0,sp,16
	char *os;

	os = s;
	while (n-- > 0 && (*s++ = *t++) != 0)
    80204454:	00050793          	mv	a5,a0
    80204458:	0140006f          	j	8020446c <strncpy+0x24>
    8020445c:	0005c683          	lbu	a3,0(a1)
    80204460:	00158593          	addi	a1,a1,1
    80204464:	fed78fa3          	sb	a3,-1(a5)
    80204468:	02068063          	beqz	a3,80204488 <strncpy+0x40>
    8020446c:	00060713          	mv	a4,a2
    80204470:	00178793          	addi	a5,a5,1
    80204474:	fff6061b          	addiw	a2,a2,-1
    80204478:	fee042e3          	bgtz	a4,8020445c <strncpy+0x14>
		;
	while (n-- > 0)
		*s++ = 0;
	return os;
}
    8020447c:	00813403          	ld	s0,8(sp)
    80204480:	01010113          	addi	sp,sp,16
    80204484:	00008067          	ret
	while (n-- > 0)
    80204488:	00f7073b          	addw	a4,a4,a5
    8020448c:	fff7071b          	addiw	a4,a4,-1
    80204490:	fe0606e3          	beqz	a2,8020447c <strncpy+0x34>
		*s++ = 0;
    80204494:	00178793          	addi	a5,a5,1
	while (n-- > 0)
    80204498:	40f706bb          	subw	a3,a4,a5
		*s++ = 0;
    8020449c:	fe078fa3          	sb	zero,-1(a5)
	while (n-- > 0)
    802044a0:	fed04ae3          	bgtz	a3,80204494 <strncpy+0x4c>
}
    802044a4:	00813403          	ld	s0,8(sp)
    802044a8:	01010113          	addi	sp,sp,16
    802044ac:	00008067          	ret

00000000802044b0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char *safestrcpy(char *s, const char *t, int n)
{
    802044b0:	ff010113          	addi	sp,sp,-16
    802044b4:	00813423          	sd	s0,8(sp)
    802044b8:	01010413          	addi	s0,sp,16
	char *os;

	os = s;
	if (n <= 0)
    802044bc:	02c05a63          	blez	a2,802044f0 <safestrcpy+0x40>
    802044c0:	fff6069b          	addiw	a3,a2,-1
    802044c4:	02069693          	slli	a3,a3,0x20
    802044c8:	0206d693          	srli	a3,a3,0x20
    802044cc:	00d586b3          	add	a3,a1,a3
    802044d0:	00050793          	mv	a5,a0
		return os;
	while (--n > 0 && (*s++ = *t++) != 0)
    802044d4:	00d58c63          	beq	a1,a3,802044ec <safestrcpy+0x3c>
    802044d8:	0005c703          	lbu	a4,0(a1)
    802044dc:	00178793          	addi	a5,a5,1
    802044e0:	00158593          	addi	a1,a1,1
    802044e4:	fee78fa3          	sb	a4,-1(a5)
    802044e8:	fe0716e3          	bnez	a4,802044d4 <safestrcpy+0x24>
		;
	*s = 0;
    802044ec:	00078023          	sb	zero,0(a5)
	return os;
}
    802044f0:	00813403          	ld	s0,8(sp)
    802044f4:	01010113          	addi	sp,sp,16
    802044f8:	00008067          	ret

00000000802044fc <strlen>:

int strlen(const char *s)
{
    802044fc:	ff010113          	addi	sp,sp,-16
    80204500:	00813423          	sd	s0,8(sp)
    80204504:	01010413          	addi	s0,sp,16
	int n;

	for (n = 0; s[n]; n++)
    80204508:	00054783          	lbu	a5,0(a0)
    8020450c:	02078863          	beqz	a5,8020453c <strlen+0x40>
    80204510:	00150513          	addi	a0,a0,1
    80204514:	00050793          	mv	a5,a0
    80204518:	0007c703          	lbu	a4,0(a5)
    8020451c:	00078693          	mv	a3,a5
    80204520:	00178793          	addi	a5,a5,1
    80204524:	fe071ae3          	bnez	a4,80204518 <strlen+0x1c>
		;
	return n;
}
    80204528:	00813403          	ld	s0,8(sp)
	for (n = 0; s[n]; n++)
    8020452c:	40a6853b          	subw	a0,a3,a0
    80204530:	0015051b          	addiw	a0,a0,1
}
    80204534:	01010113          	addi	sp,sp,16
    80204538:	00008067          	ret
    8020453c:	00813403          	ld	s0,8(sp)
	for (n = 0; s[n]; n++)
    80204540:	00000513          	li	a0,0
}
    80204544:	01010113          	addi	sp,sp,16
    80204548:	00008067          	ret

000000008020454c <dummy>:

void dummy(int _, ...)
{
    8020454c:	fb010113          	addi	sp,sp,-80
    80204550:	00813423          	sd	s0,8(sp)
    80204554:	01010413          	addi	s0,sp,16
    80204558:	00b43423          	sd	a1,8(s0)
    8020455c:	00c43823          	sd	a2,16(s0)
    80204560:	00d43c23          	sd	a3,24(s0)
    80204564:	02e43023          	sd	a4,32(s0)
    80204568:	02f43423          	sd	a5,40(s0)
    8020456c:	03043823          	sd	a6,48(s0)
    80204570:	03143c23          	sd	a7,56(s0)
    80204574:	00813403          	ld	s0,8(sp)
    80204578:	05010113          	addi	sp,sp,80
    8020457c:	00008067          	ret

0000000080204580 <get_cycle>:

#include "riscv.h"
#include "sbi.h"

/// read the `mtime` regiser
uint64 get_cycle() {
    80204580:	ff010113          	addi	sp,sp,-16
    80204584:	00813423          	sd	s0,8(sp)
    80204588:	01010413          	addi	s0,sp,16
    asm volatile("csrr %0, time" : "=r"(x));
    8020458c:	c0102573          	rdtime	a0
    return r_time();
}
    80204590:	00813403          	ld	s0,8(sp)
    80204594:	01010113          	addi	sp,sp,16
    80204598:	00008067          	ret

000000008020459c <timer_init>:

/// Enable timer interrupt
void timer_init() {
    8020459c:	ff010113          	addi	sp,sp,-16
    802045a0:	00813423          	sd	s0,8(sp)
    802045a4:	01010413          	addi	s0,sp,16
    asm volatile("csrr %0, sie" : "=r"(x));
    802045a8:	104027f3          	csrr	a5,sie
    // Enable supervisor timer interrupt
    w_sie(r_sie() | SIE_STIE);
    802045ac:	0207e793          	ori	a5,a5,32
    asm volatile("csrw sie, %0" : : "r"(x));
    802045b0:	10479073          	csrw	sie,a5
    asm volatile("csrr %0, time" : "=r"(x));
    802045b4:	c0102573          	rdtime	a0
    set_next_timer();
}
    802045b8:	00813403          	ld	s0,8(sp)

// /// Set the next timer interrupt
void set_next_timer() {
    const uint64 timebase = CPU_FREQ / TICKS_PER_SEC;
    set_timer(get_cycle() + timebase);
    802045bc:	002627b7          	lui	a5,0x262
    802045c0:	5a078793          	addi	a5,a5,1440 # 2625a0 <_entry-0x7ff9da60>
    802045c4:	00f50533          	add	a0,a0,a5
}
    802045c8:	01010113          	addi	sp,sp,16
    set_timer(get_cycle() + timebase);
    802045cc:	fffff317          	auipc	t1,0xfffff
    802045d0:	2ec30067          	jr	748(t1) # 802038b8 <set_timer>

00000000802045d4 <set_next_timer>:
void set_next_timer() {
    802045d4:	ff010113          	addi	sp,sp,-16
    802045d8:	00813423          	sd	s0,8(sp)
    802045dc:	01010413          	addi	s0,sp,16
    802045e0:	c0102573          	rdtime	a0
}
    802045e4:	00813403          	ld	s0,8(sp)
    set_timer(get_cycle() + timebase);
    802045e8:	002627b7          	lui	a5,0x262
    802045ec:	5a078793          	addi	a5,a5,1440 # 2625a0 <_entry-0x7ff9da60>
    802045f0:	00f50533          	add	a0,a0,a5
}
    802045f4:	01010113          	addi	sp,sp,16
    set_timer(get_cycle() + timebase);
    802045f8:	fffff317          	auipc	t1,0xfffff
    802045fc:	2c030067          	jr	704(t1) # 802038b8 <set_timer>

0000000080204600 <sleepms>:

void sleepms(uint64 ms) {
    80204600:	ff010113          	addi	sp,sp,-16
    80204604:	00813423          	sd	s0,8(sp)
    80204608:	01010413          	addi	s0,sp,16
    8020460c:	c0102773          	rdtime	a4
    uint64 now = r_time();
    uint64 diff = ms * CPU_FREQ / 1000;
    80204610:	009897b7          	lui	a5,0x989
    80204614:	68078793          	addi	a5,a5,1664 # 989680 <_entry-0x7f876980>
    80204618:	02f506b3          	mul	a3,a0,a5
    8020461c:	3e800793          	li	a5,1000
    80204620:	02f6d6b3          	divu	a3,a3,a5
    80204624:	c01027f3          	rdtime	a5
    while (r_time() - now < diff || r_time() < now) {
    80204628:	40e787b3          	sub	a5,a5,a4
    8020462c:	00d7e663          	bltu	a5,a3,80204638 <sleepms+0x38>
    80204630:	c01027f3          	rdtime	a5
    80204634:	00e7f463          	bgeu	a5,a4,8020463c <sleepms+0x3c>
        asm volatile("":::"memory");
    80204638:	fedff06f          	j	80204624 <sleepms+0x24>
    }
    8020463c:	00813403          	ld	s0,8(sp)
    80204640:	01010113          	addi	sp,sp,16
    80204644:	00008067          	ret

0000000080204648 <curr_proc>:
        goto kernel_panic;
    }

    assert(!intr_get());
    assert(mycpu()->inkernel_trap == 1);

    80204648:	fe010113          	addi	sp,sp,-32
    8020464c:	00113c23          	sd	ra,24(sp)
    80204650:	00813823          	sd	s0,16(sp)
    80204654:	00913423          	sd	s1,8(sp)
    80204658:	02010413          	addi	s0,sp,32
    mycpu()->inkernel_trap--;
    8020465c:	ffffd097          	auipc	ra,0xffffd
    80204660:	308080e7          	jalr	776(ra) # 80201964 <push_off>

    80204664:	00000097          	auipc	ra,0x0
    80204668:	a88080e7          	jalr	-1400(ra) # 802040ec <mycpu>
    return;
    8020466c:	00853483          	ld	s1,8(a0)

    80204670:	ffffd097          	auipc	ra,0xffffd
    80204674:	368080e7          	jalr	872(ra) # 802019d8 <pop_off>
kernel_panic:
    // lock against other cpu, to show a complete panic message.
    80204678:	01813083          	ld	ra,24(sp)
    8020467c:	01013403          	ld	s0,16(sp)
    80204680:	00048513          	mv	a0,s1
    80204684:	00813483          	ld	s1,8(sp)
    80204688:	02010113          	addi	sp,sp,32
    8020468c:	00008067          	ret

0000000080204690 <set_kerneltrap.part.0>:
    __sync_lock_release(&kp_print_lock);

    panic("kernel panic");
}

void set_kerneltrap() {
    80204690:	fe010113          	addi	sp,sp,-32
    80204694:	00813823          	sd	s0,16(sp)
    80204698:	00113c23          	sd	ra,24(sp)
    8020469c:	00913423          	sd	s1,8(sp)
    802046a0:	01213023          	sd	s2,0(sp)
    802046a4:	02010413          	addi	s0,sp,32
    asm volatile("mv %0, tp" : "=r"(x));
    802046a8:	00020493          	mv	s1,tp
    push_off();
    802046ac:	ffffd097          	auipc	ra,0xffffd
    802046b0:	2b8080e7          	jalr	696(ra) # 80201964 <push_off>
    struct cpu* c = mycpu();
    802046b4:	00000097          	auipc	ra,0x0
    802046b8:	a38080e7          	jalr	-1480(ra) # 802040ec <mycpu>
    struct proc* p = c->proc;
    802046bc:	00853903          	ld	s2,8(a0)
    return r_tp();
    802046c0:	0004849b          	sext.w	s1,s1
    pop_off();
    802046c4:	ffffd097          	auipc	ra,0xffffd
    802046c8:	314080e7          	jalr	788(ra) # 802019d8 <pop_off>
    802046cc:	02090e63          	beqz	s2,80204708 <set_kerneltrap.part.0+0x78>
    802046d0:	02492703          	lw	a4,36(s2)
    assert(IS_ALIGNED((uint64)kernel_trap_entry, 4));
    802046d4:	00002897          	auipc	a7,0x2
    802046d8:	98488893          	addi	a7,a7,-1660 # 80206058 <e_text+0x1058>
    802046dc:	06000813          	li	a6,96
    802046e0:	00002797          	auipc	a5,0x2
    802046e4:	9a878793          	addi	a5,a5,-1624 # 80206088 <e_text+0x1088>
    802046e8:	00048693          	mv	a3,s1
    802046ec:	00001617          	auipc	a2,0x1
    802046f0:	93c60613          	addi	a2,a2,-1732 # 80205028 <e_text+0x28>
    802046f4:	01f00593          	li	a1,31
    802046f8:	00001517          	auipc	a0,0x1
    802046fc:	93850513          	addi	a0,a0,-1736 # 80205030 <e_text+0x30>
    80204700:	ffffe097          	auipc	ra,0xffffe
    80204704:	184080e7          	jalr	388(ra) # 80202884 <__panic>
    80204708:	fff00713          	li	a4,-1
    8020470c:	fc9ff06f          	j	802046d4 <set_kerneltrap.part.0+0x44>

0000000080204710 <plic_handle>:
void plic_handle() {
    80204710:	fe010113          	addi	sp,sp,-32
    80204714:	00813823          	sd	s0,16(sp)
    80204718:	00113c23          	sd	ra,24(sp)
    8020471c:	02010413          	addi	s0,sp,32
    int irq = plic_claim();
    80204720:	ffffe097          	auipc	ra,0xffffe
    80204724:	01c080e7          	jalr	28(ra) # 8020273c <plic_claim>
    if (irq == UART0_IRQ) {
    80204728:	00a00793          	li	a5,10
    8020472c:	02f50663          	beq	a0,a5,80204758 <plic_handle+0x48>
    if (irq)
    80204730:	00050c63          	beqz	a0,80204748 <plic_handle+0x38>
}
    80204734:	01013403          	ld	s0,16(sp)
    80204738:	01813083          	ld	ra,24(sp)
    8020473c:	02010113          	addi	sp,sp,32
        plic_complete(irq);
    80204740:	ffffe317          	auipc	t1,0xffffe
    80204744:	03830067          	jr	56(t1) # 80202778 <plic_complete>
}
    80204748:	01813083          	ld	ra,24(sp)
    8020474c:	01013403          	ld	s0,16(sp)
    80204750:	02010113          	addi	sp,sp,32
    80204754:	00008067          	ret
    80204758:	fea43423          	sd	a0,-24(s0)
        uart_intr();
    8020475c:	ffffc097          	auipc	ra,0xffffc
    80204760:	c94080e7          	jalr	-876(ra) # 802003f0 <uart_intr>
    if (irq)
    80204764:	fe843503          	ld	a0,-24(s0)
}
    80204768:	01013403          	ld	s0,16(sp)
    8020476c:	01813083          	ld	ra,24(sp)
    80204770:	02010113          	addi	sp,sp,32
        plic_complete(irq);
    80204774:	ffffe317          	auipc	t1,0xffffe
    80204778:	00430067          	jr	4(t1) # 80202778 <plic_complete>

000000008020477c <kernel_trap>:
void kernel_trap(struct ktrapframe *ktf) {
    8020477c:	fc010113          	addi	sp,sp,-64
    80204780:	02813823          	sd	s0,48(sp)
    80204784:	02113c23          	sd	ra,56(sp)
    80204788:	04010413          	addi	s0,sp,64
    asm volatile("csrr %0, sstatus" : "=r"(x));
    8020478c:	100027f3          	csrr	a5,sstatus
    return (x & SSTATUS_SIE) != 0;
    80204790:	0027f793          	andi	a5,a5,2
    80204794:	02913423          	sd	s1,40(sp)
    80204798:	03213023          	sd	s2,32(sp)
    8020479c:	01313c23          	sd	s3,24(sp)
    assert(!intr_get());
    802047a0:	2c079c63          	bnez	a5,80204a78 <kernel_trap+0x2fc>
    802047a4:	00050913          	mv	s2,a0
    asm volatile("csrr %0, sstatus" : "=r"(x));
    802047a8:	100027f3          	csrr	a5,sstatus
    if ((r_sstatus() & SSTATUS_SPP) == 0) {
    802047ac:	1007f793          	andi	a5,a5,256
    802047b0:	30078c63          	beqz	a5,80204ac8 <kernel_trap+0x34c>
    mycpu()->inkernel_trap++;
    802047b4:	00000097          	auipc	ra,0x0
    802047b8:	938080e7          	jalr	-1736(ra) # 802040ec <mycpu>
    802047bc:	08052783          	lw	a5,128(a0)
    802047c0:	0017879b          	addiw	a5,a5,1
    802047c4:	08f52023          	sw	a5,128(a0)
    asm volatile("csrr %0, scause" : "=r"(x));
    802047c8:	142029f3          	csrr	s3,scause
    uint64 exception_code = cause & SCAUSE_EXCEPTION_CODE_MASK;
    802047cc:	00199493          	slli	s1,s3,0x1
    802047d0:	0014d493          	srli	s1,s1,0x1
    if (cause & SCAUSE_INTERRUPT) {
    802047d4:	1609da63          	bgez	s3,80204948 <kernel_trap+0x1cc>
        if (mycpu()->inkernel_trap > 1) {
    802047d8:	00000097          	auipc	ra,0x0
    802047dc:	914080e7          	jalr	-1772(ra) # 802040ec <mycpu>
    802047e0:	08052703          	lw	a4,128(a0)
    802047e4:	00100793          	li	a5,1
    802047e8:	34e7c863          	blt	a5,a4,80204b38 <kernel_trap+0x3bc>
        if (panicked) {
    802047ec:	0001a797          	auipc	a5,0x1a
    802047f0:	b5c7a783          	lw	a5,-1188(a5) # 8021e348 <panicked>
    802047f4:	22079e63          	bnez	a5,80204a30 <kernel_trap+0x2b4>
        switch (exception_code) {
    802047f8:	00500793          	li	a5,5
    802047fc:	02f48c63          	beq	s1,a5,80204834 <kernel_trap+0xb8>
    80204800:	00900793          	li	a5,9
    80204804:	10f49063          	bne	s1,a5,80204904 <kernel_trap+0x188>
                tracef("s-external interrupt.");
    80204808:	00000513          	li	a0,0
    8020480c:	00000097          	auipc	ra,0x0
    80204810:	d40080e7          	jalr	-704(ra) # 8020454c <dummy>
    int irq = plic_claim();
    80204814:	ffffe097          	auipc	ra,0xffffe
    80204818:	f28080e7          	jalr	-216(ra) # 8020273c <plic_claim>
    if (irq == UART0_IRQ) {
    8020481c:	00a00793          	li	a5,10
    80204820:	0cf50463          	beq	a0,a5,802048e8 <kernel_trap+0x16c>
    if (irq)
    80204824:	06050a63          	beqz	a0,80204898 <kernel_trap+0x11c>
        plic_complete(irq);
    80204828:	ffffe097          	auipc	ra,0xffffe
    8020482c:	f50080e7          	jalr	-176(ra) # 80202778 <plic_complete>
    80204830:	0680006f          	j	80204898 <kernel_trap+0x11c>
    asm volatile("csrr %0, time" : "=r"(x));
    80204834:	c01025f3          	rdtime	a1
                tracef("s-timer interrupt, cycle: %d", r_time());
    80204838:	00000513          	li	a0,0
    8020483c:	00000097          	auipc	ra,0x0
    80204840:	d10080e7          	jalr	-752(ra) # 8020454c <dummy>
                set_next_timer();
    80204844:	00000097          	auipc	ra,0x0
    80204848:	d90080e7          	jalr	-624(ra) # 802045d4 <set_next_timer>
    push_off();
    8020484c:	ffffd097          	auipc	ra,0xffffd
    80204850:	118080e7          	jalr	280(ra) # 80201964 <push_off>
    struct cpu* c = mycpu();
    80204854:	00000097          	auipc	ra,0x0
    80204858:	898080e7          	jalr	-1896(ra) # 802040ec <mycpu>
    struct proc* p = c->proc;
    8020485c:	00853483          	ld	s1,8(a0)
    pop_off();
    80204860:	ffffd097          	auipc	ra,0xffffd
    80204864:	178080e7          	jalr	376(ra) # 802019d8 <pop_off>
                if (p != NULL) {  // 确保不是scheduler线程（curr_proc()为NULL）
    80204868:	02048863          	beqz	s1,80204898 <kernel_trap+0x11c>
                    int saved_inkernel     = mycpu()->inkernel_trap;
    8020486c:	00000097          	auipc	ra,0x0
    80204870:	880080e7          	jalr	-1920(ra) # 802040ec <mycpu>
    80204874:	08052483          	lw	s1,128(a0)
                    mycpu()->inkernel_trap = 0;               // 临时清除inkernel_trap计数器
    80204878:	00000097          	auipc	ra,0x0
    8020487c:	874080e7          	jalr	-1932(ra) # 802040ec <mycpu>
    80204880:	08052023          	sw	zero,128(a0)
                    yield();                                  // 调用yield切换进程
    80204884:	fffff097          	auipc	ra,0xfffff
    80204888:	7ec080e7          	jalr	2028(ra) # 80204070 <yield>
                    mycpu()->inkernel_trap = saved_inkernel;  // 恢复计数器
    8020488c:	00000097          	auipc	ra,0x0
    80204890:	860080e7          	jalr	-1952(ra) # 802040ec <mycpu>
    80204894:	08952023          	sw	s1,128(a0)
    asm volatile("csrr %0, sstatus" : "=r"(x));
    80204898:	100027f3          	csrr	a5,sstatus
    return (x & SSTATUS_SIE) != 0;
    8020489c:	0027f793          	andi	a5,a5,2
    assert(!intr_get());
    802048a0:	26079663          	bnez	a5,80204b0c <kernel_trap+0x390>
    assert(mycpu()->inkernel_trap == 1);
    802048a4:	00000097          	auipc	ra,0x0
    802048a8:	848080e7          	jalr	-1976(ra) # 802040ec <mycpu>
    802048ac:	08052703          	lw	a4,128(a0)
    802048b0:	00100793          	li	a5,1
    802048b4:	2ef71063          	bne	a4,a5,80204b94 <kernel_trap+0x418>
    mycpu()->inkernel_trap--;
    802048b8:	00000097          	auipc	ra,0x0
    802048bc:	834080e7          	jalr	-1996(ra) # 802040ec <mycpu>
    802048c0:	08052783          	lw	a5,128(a0)
}
    802048c4:	03813083          	ld	ra,56(sp)
    802048c8:	03013403          	ld	s0,48(sp)
    mycpu()->inkernel_trap--;
    802048cc:	fff7879b          	addiw	a5,a5,-1
    802048d0:	08f52023          	sw	a5,128(a0)
    panic("kernel panic");
    802048d4:	02813483          	ld	s1,40(sp)
    802048d8:	02013903          	ld	s2,32(sp)
    802048dc:	01813983          	ld	s3,24(sp)
}
    802048e0:	04010113          	addi	sp,sp,64
    802048e4:	00008067          	ret
    802048e8:	fca43423          	sd	a0,-56(s0)
        uart_intr();
    802048ec:	ffffc097          	auipc	ra,0xffffc
    802048f0:	b04080e7          	jalr	-1276(ra) # 802003f0 <uart_intr>
    if (irq)
    802048f4:	fc843503          	ld	a0,-56(s0)
        plic_complete(irq);
    802048f8:	ffffe097          	auipc	ra,0xffffe
    802048fc:	e80080e7          	jalr	-384(ra) # 80202778 <plic_complete>
    80204900:	f99ff06f          	j	80204898 <kernel_trap+0x11c>
    asm volatile("mv %0, tp" : "=r"(x));
    80204904:	00020493          	mv	s1,tp
    return r_tp();
    80204908:	0004849b          	sext.w	s1,s1
    struct proc *p = curr_proc();
    8020490c:	00000097          	auipc	ra,0x0
    80204910:	d3c080e7          	jalr	-708(ra) # 80204648 <curr_proc>
    return p ? p->pid : -1;
    80204914:	2a050a63          	beqz	a0,80204bc8 <kernel_trap+0x44c>
    80204918:	02452703          	lw	a4,36(a0)
                errorf("unhandled interrupt: %d", cause);
    8020491c:	00098813          	mv	a6,s3
    80204920:	00002797          	auipc	a5,0x2
    80204924:	9c878793          	addi	a5,a5,-1592 # 802062e8 <__func__.0>
    80204928:	00048693          	mv	a3,s1
    8020492c:	00001617          	auipc	a2,0x1
    80204930:	76c60613          	addi	a2,a2,1900 # 80206098 <e_text+0x1098>
    80204934:	01f00593          	li	a1,31
    80204938:	00002517          	auipc	a0,0x2
    8020493c:	81050513          	addi	a0,a0,-2032 # 80206148 <e_text+0x1148>
    80204940:	ffffe097          	auipc	ra,0xffffe
    80204944:	244080e7          	jalr	580(ra) # 80202b84 <printf>
                goto kernel_panic;
    80204948:	01413823          	sd	s4,16(sp)
    8020494c:	0001a497          	auipc	s1,0x1a
    80204950:	a6448493          	addi	s1,s1,-1436 # 8021e3b0 <kp_print_lock>
    while (__sync_lock_test_and_set(&kp_print_lock, 1) != 0);
    80204954:	00100713          	li	a4,1
    80204958:	00070793          	mv	a5,a4
    8020495c:	0cf4b7af          	amoswap.d.aq	a5,a5,(s1)
    80204960:	fe079ce3          	bnez	a5,80204958 <kernel_trap+0x1dc>
    80204964:	00020993          	mv	s3,tp
    push_off();
    80204968:	ffffd097          	auipc	ra,0xffffd
    8020496c:	ffc080e7          	jalr	-4(ra) # 80201964 <push_off>
    struct cpu* c = mycpu();
    80204970:	fffff097          	auipc	ra,0xfffff
    80204974:	77c080e7          	jalr	1916(ra) # 802040ec <mycpu>
    struct proc* p = c->proc;
    80204978:	00853a03          	ld	s4,8(a0)
    return r_tp();
    8020497c:	0009899b          	sext.w	s3,s3
    pop_off();
    80204980:	ffffd097          	auipc	ra,0xffffd
    80204984:	058080e7          	jalr	88(ra) # 802019d8 <pop_off>
    80204988:	260a0863          	beqz	s4,80204bf8 <kernel_trap+0x47c>
    8020498c:	024a2703          	lw	a4,36(s4)
    errorf("=========== Kernel Panic ===========");
    80204990:	00002797          	auipc	a5,0x2
    80204994:	95878793          	addi	a5,a5,-1704 # 802062e8 <__func__.0>
    80204998:	00098693          	mv	a3,s3
    8020499c:	00001617          	auipc	a2,0x1
    802049a0:	6fc60613          	addi	a2,a2,1788 # 80206098 <e_text+0x1098>
    802049a4:	01f00593          	li	a1,31
    802049a8:	00001517          	auipc	a0,0x1
    802049ac:	7f850513          	addi	a0,a0,2040 # 802061a0 <e_text+0x11a0>
    802049b0:	ffffe097          	auipc	ra,0xffffe
    802049b4:	1d4080e7          	jalr	468(ra) # 80202b84 <printf>
    print_sysregs(true);
    802049b8:	00100513          	li	a0,1
    802049bc:	ffffc097          	auipc	ra,0xffffc
    802049c0:	214080e7          	jalr	532(ra) # 80200bd0 <print_sysregs>
    print_ktrapframe(ktf);
    802049c4:	00090513          	mv	a0,s2
    802049c8:	ffffc097          	auipc	ra,0xffffc
    802049cc:	f90080e7          	jalr	-112(ra) # 80200958 <print_ktrapframe>
    __sync_lock_release(&kp_print_lock);
    802049d0:	0f50000f          	fence	iorw,ow
    802049d4:	0804b02f          	amoswap.d	zero,zero,(s1)
    802049d8:	00020493          	mv	s1,tp
    push_off();
    802049dc:	ffffd097          	auipc	ra,0xffffd
    802049e0:	f88080e7          	jalr	-120(ra) # 80201964 <push_off>
    struct cpu* c = mycpu();
    802049e4:	fffff097          	auipc	ra,0xfffff
    802049e8:	708080e7          	jalr	1800(ra) # 802040ec <mycpu>
    struct proc* p = c->proc;
    802049ec:	00853903          	ld	s2,8(a0)
    return r_tp();
    802049f0:	0004849b          	sext.w	s1,s1
    pop_off();
    802049f4:	ffffd097          	auipc	ra,0xffffd
    802049f8:	fe4080e7          	jalr	-28(ra) # 802019d8 <pop_off>
    802049fc:	1c090263          	beqz	s2,80204bc0 <kernel_trap+0x444>
    80204a00:	02492703          	lw	a4,36(s2)
    panic("kernel panic");
    80204a04:	05c00813          	li	a6,92
    80204a08:	00001797          	auipc	a5,0x1
    80204a0c:	68078793          	addi	a5,a5,1664 # 80206088 <e_text+0x1088>
    80204a10:	00048693          	mv	a3,s1
    80204a14:	00000617          	auipc	a2,0x0
    80204a18:	61460613          	addi	a2,a2,1556 # 80205028 <e_text+0x28>
    80204a1c:	01f00593          	li	a1,31
    80204a20:	00001517          	auipc	a0,0x1
    80204a24:	7c050513          	addi	a0,a0,1984 # 802061e0 <e_text+0x11e0>
    80204a28:	ffffe097          	auipc	ra,0xffffe
    80204a2c:	e5c080e7          	jalr	-420(ra) # 80202884 <__panic>
    80204a30:	01413823          	sd	s4,16(sp)
    80204a34:	00020493          	mv	s1,tp
    return r_tp();
    80204a38:	0004849b          	sext.w	s1,s1
    struct proc *p = curr_proc();
    80204a3c:	00000097          	auipc	ra,0x0
    80204a40:	c0c080e7          	jalr	-1012(ra) # 80204648 <curr_proc>
    return p ? p->pid : -1;
    80204a44:	1a050263          	beqz	a0,80204be8 <kernel_trap+0x46c>
    80204a48:	02452703          	lw	a4,36(a0)
            panic("other CPU has panicked");
    80204a4c:	02d00813          	li	a6,45
    80204a50:	00001797          	auipc	a5,0x1
    80204a54:	63878793          	addi	a5,a5,1592 # 80206088 <e_text+0x1088>
    80204a58:	00048693          	mv	a3,s1
    80204a5c:	00000617          	auipc	a2,0x0
    80204a60:	5cc60613          	addi	a2,a2,1484 # 80205028 <e_text+0x28>
    80204a64:	01f00593          	li	a1,31
    80204a68:	00001517          	auipc	a0,0x1
    80204a6c:	6a850513          	addi	a0,a0,1704 # 80206110 <e_text+0x1110>
    80204a70:	ffffe097          	auipc	ra,0xffffe
    80204a74:	e14080e7          	jalr	-492(ra) # 80202884 <__panic>
    80204a78:	01413823          	sd	s4,16(sp)
    80204a7c:	00020493          	mv	s1,tp
    80204a80:	0004849b          	sext.w	s1,s1
    struct proc *p = curr_proc();
    80204a84:	00000097          	auipc	ra,0x0
    80204a88:	bc4080e7          	jalr	-1084(ra) # 80204648 <curr_proc>
    return p ? p->pid : -1;
    80204a8c:	14050663          	beqz	a0,80204bd8 <kernel_trap+0x45c>
    80204a90:	02452703          	lw	a4,36(a0)
    assert(!intr_get());
    80204a94:	00001897          	auipc	a7,0x1
    80204a98:	3f488893          	addi	a7,a7,1012 # 80205e88 <e_text+0xe88>
    80204a9c:	01800813          	li	a6,24
    assert(!intr_get());
    80204aa0:	00001797          	auipc	a5,0x1
    80204aa4:	5e878793          	addi	a5,a5,1512 # 80206088 <e_text+0x1088>
    80204aa8:	00048693          	mv	a3,s1
    80204aac:	00000617          	auipc	a2,0x0
    80204ab0:	57c60613          	addi	a2,a2,1404 # 80205028 <e_text+0x28>
    80204ab4:	01f00593          	li	a1,31
    80204ab8:	00000517          	auipc	a0,0x0
    80204abc:	57850513          	addi	a0,a0,1400 # 80205030 <e_text+0x30>
    80204ac0:	ffffe097          	auipc	ra,0xffffe
    80204ac4:	dc4080e7          	jalr	-572(ra) # 80202884 <__panic>
    80204ac8:	00020493          	mv	s1,tp
    80204acc:	0004849b          	sext.w	s1,s1
    struct proc *p = curr_proc();
    80204ad0:	00000097          	auipc	ra,0x0
    80204ad4:	b78080e7          	jalr	-1160(ra) # 80204648 <curr_proc>
    return p ? p->pid : -1;
    80204ad8:	10050c63          	beqz	a0,80204bf0 <kernel_trap+0x474>
    80204adc:	02452703          	lw	a4,36(a0)
        errorf("kerneltrap: not from supervisor mode");
    80204ae0:	00002797          	auipc	a5,0x2
    80204ae4:	80878793          	addi	a5,a5,-2040 # 802062e8 <__func__.0>
    80204ae8:	00048693          	mv	a3,s1
    80204aec:	00001617          	auipc	a2,0x1
    80204af0:	5ac60613          	addi	a2,a2,1452 # 80206098 <e_text+0x1098>
    80204af4:	01f00593          	li	a1,31
    80204af8:	00001517          	auipc	a0,0x1
    80204afc:	5a850513          	addi	a0,a0,1448 # 802060a0 <e_text+0x10a0>
    80204b00:	ffffe097          	auipc	ra,0xffffe
    80204b04:	084080e7          	jalr	132(ra) # 80202b84 <printf>
        goto kernel_panic;
    80204b08:	e41ff06f          	j	80204948 <kernel_trap+0x1cc>
    80204b0c:	01413823          	sd	s4,16(sp)
    80204b10:	00020493          	mv	s1,tp
    80204b14:	0004849b          	sext.w	s1,s1
    struct proc *p = curr_proc();
    80204b18:	00000097          	auipc	ra,0x0
    80204b1c:	b30080e7          	jalr	-1232(ra) # 80204648 <curr_proc>
    return p ? p->pid : -1;
    80204b20:	0a050863          	beqz	a0,80204bd0 <kernel_trap+0x454>
    80204b24:	02452703          	lw	a4,36(a0)
    assert(!intr_get());
    80204b28:	00001897          	auipc	a7,0x1
    80204b2c:	36088893          	addi	a7,a7,864 # 80205e88 <e_text+0xe88>
    80204b30:	04a00813          	li	a6,74
    80204b34:	f6dff06f          	j	80204aa0 <kernel_trap+0x324>
            print_sysregs(true);
    80204b38:	00100513          	li	a0,1
    80204b3c:	ffffc097          	auipc	ra,0xffffc
    80204b40:	094080e7          	jalr	148(ra) # 80200bd0 <print_sysregs>
            print_ktrapframe(ktf);
    80204b44:	00090513          	mv	a0,s2
    80204b48:	ffffc097          	auipc	ra,0xffffc
    80204b4c:	e10080e7          	jalr	-496(ra) # 80200958 <print_ktrapframe>
    80204b50:	00020493          	mv	s1,tp
    80204b54:	0004849b          	sext.w	s1,s1
    struct proc *p = curr_proc();
    80204b58:	00000097          	auipc	ra,0x0
    80204b5c:	af0080e7          	jalr	-1296(ra) # 80204648 <curr_proc>
    return p ? p->pid : -1;
    80204b60:	08050063          	beqz	a0,80204be0 <kernel_trap+0x464>
    80204b64:	02452703          	lw	a4,36(a0)
            errorf("nested kerneltrap");
    80204b68:	00001797          	auipc	a5,0x1
    80204b6c:	78078793          	addi	a5,a5,1920 # 802062e8 <__func__.0>
    80204b70:	00048693          	mv	a3,s1
    80204b74:	00001617          	auipc	a2,0x1
    80204b78:	52460613          	addi	a2,a2,1316 # 80206098 <e_text+0x1098>
    80204b7c:	01f00593          	li	a1,31
    80204b80:	00001517          	auipc	a0,0x1
    80204b84:	56050513          	addi	a0,a0,1376 # 802060e0 <e_text+0x10e0>
    80204b88:	ffffe097          	auipc	ra,0xffffe
    80204b8c:	ffc080e7          	jalr	-4(ra) # 80202b84 <printf>
            goto kernel_panic;
    80204b90:	db9ff06f          	j	80204948 <kernel_trap+0x1cc>
    80204b94:	01413823          	sd	s4,16(sp)
    80204b98:	00020493          	mv	s1,tp
    80204b9c:	0004849b          	sext.w	s1,s1
    struct proc *p = curr_proc();
    80204ba0:	00000097          	auipc	ra,0x0
    80204ba4:	aa8080e7          	jalr	-1368(ra) # 80204648 <curr_proc>
    return p ? p->pid : -1;
    80204ba8:	04050c63          	beqz	a0,80204c00 <kernel_trap+0x484>
    80204bac:	02452703          	lw	a4,36(a0)
    assert(mycpu()->inkernel_trap == 1);
    80204bb0:	00001897          	auipc	a7,0x1
    80204bb4:	5d088893          	addi	a7,a7,1488 # 80206180 <e_text+0x1180>
    80204bb8:	04b00813          	li	a6,75
    80204bbc:	ee5ff06f          	j	80204aa0 <kernel_trap+0x324>
    80204bc0:	fff00713          	li	a4,-1
    80204bc4:	e41ff06f          	j	80204a04 <kernel_trap+0x288>
    80204bc8:	fff00713          	li	a4,-1
    80204bcc:	d51ff06f          	j	8020491c <kernel_trap+0x1a0>
    80204bd0:	fff00713          	li	a4,-1
    80204bd4:	f55ff06f          	j	80204b28 <kernel_trap+0x3ac>
    80204bd8:	fff00713          	li	a4,-1
    80204bdc:	eb9ff06f          	j	80204a94 <kernel_trap+0x318>
    80204be0:	fff00713          	li	a4,-1
    80204be4:	f85ff06f          	j	80204b68 <kernel_trap+0x3ec>
    80204be8:	fff00713          	li	a4,-1
    80204bec:	e61ff06f          	j	80204a4c <kernel_trap+0x2d0>
    80204bf0:	fff00713          	li	a4,-1
    80204bf4:	eedff06f          	j	80204ae0 <kernel_trap+0x364>
    80204bf8:	fff00713          	li	a4,-1
    80204bfc:	d95ff06f          	j	80204990 <kernel_trap+0x214>
    80204c00:	fff00713          	li	a4,-1
    80204c04:	fadff06f          	j	80204bb0 <kernel_trap+0x434>

0000000080204c08 <set_kerneltrap>:
void set_kerneltrap() {
    80204c08:	ffffb797          	auipc	a5,0xffffb
    80204c0c:	41c78793          	addi	a5,a5,1052 # 80200024 <kernel_trap_entry>
    80204c10:	0037f713          	andi	a4,a5,3
    80204c14:	00071663          	bnez	a4,80204c20 <set_kerneltrap+0x18>
    80204c18:	10579073          	csrw	stvec,a5
    80204c1c:	00008067          	ret
    80204c20:	ff010113          	addi	sp,sp,-16
    80204c24:	00813023          	sd	s0,0(sp)
    80204c28:	00113423          	sd	ra,8(sp)
    80204c2c:	01010413          	addi	s0,sp,16
    80204c30:	00000097          	auipc	ra,0x0
    80204c34:	a60080e7          	jalr	-1440(ra) # 80204690 <set_kerneltrap.part.0>

0000000080204c38 <trap_init>:
    assert(IS_ALIGNED((uint64)kernel_trap_entry, 4));
    80204c38:	ffffb797          	auipc	a5,0xffffb
    80204c3c:	3ec78793          	addi	a5,a5,1004 # 80200024 <kernel_trap_entry>
    80204c40:	0037f713          	andi	a4,a5,3
    80204c44:	00071663          	bnez	a4,80204c50 <trap_init+0x18>
    asm volatile("csrw stvec, %0" : : "r"(x));
    80204c48:	10579073          	csrw	stvec,a5
    80204c4c:	00008067          	ret
    w_stvec((uint64)kernel_trap_entry);  // DIRECT
}

// set up to take exceptions and traps while in the kernel.
void trap_init() {
    80204c50:	ff010113          	addi	sp,sp,-16
    80204c54:	00813023          	sd	s0,0(sp)
    80204c58:	00113423          	sd	ra,8(sp)
    80204c5c:	01010413          	addi	s0,sp,16
    80204c60:	00000097          	auipc	ra,0x0
    80204c64:	a30080e7          	jalr	-1488(ra) # 80204690 <set_kerneltrap.part.0>

0000000080204c68 <swtch>:
# Save current registers in old. Load from new.


.globl swtch
swtch:
        sd ra, 0(a0)
    80204c68:	00153023          	sd	ra,0(a0)
        sd sp, 8(a0)
    80204c6c:	00253423          	sd	sp,8(a0)
        sd s0, 16(a0)
    80204c70:	00853823          	sd	s0,16(a0)
        sd s1, 24(a0)
    80204c74:	00953c23          	sd	s1,24(a0)
        sd s2, 32(a0)
    80204c78:	03253023          	sd	s2,32(a0)
        sd s3, 40(a0)
    80204c7c:	03353423          	sd	s3,40(a0)
        sd s4, 48(a0)
    80204c80:	03453823          	sd	s4,48(a0)
        sd s5, 56(a0)
    80204c84:	03553c23          	sd	s5,56(a0)
        sd s6, 64(a0)
    80204c88:	05653023          	sd	s6,64(a0)
        sd s7, 72(a0)
    80204c8c:	05753423          	sd	s7,72(a0)
        sd s8, 80(a0)
    80204c90:	05853823          	sd	s8,80(a0)
        sd s9, 88(a0)
    80204c94:	05953c23          	sd	s9,88(a0)
        sd s10, 96(a0)
    80204c98:	07a53023          	sd	s10,96(a0)
        sd s11, 104(a0)
    80204c9c:	07b53423          	sd	s11,104(a0)

        ld ra, 0(a1)
    80204ca0:	0005b083          	ld	ra,0(a1)
        ld sp, 8(a1)
    80204ca4:	0085b103          	ld	sp,8(a1)
        ld s0, 16(a1)
    80204ca8:	0105b403          	ld	s0,16(a1)
        ld s1, 24(a1)
    80204cac:	0185b483          	ld	s1,24(a1)
        ld s2, 32(a1)
    80204cb0:	0205b903          	ld	s2,32(a1)
        ld s3, 40(a1)
    80204cb4:	0285b983          	ld	s3,40(a1)
        ld s4, 48(a1)
    80204cb8:	0305ba03          	ld	s4,48(a1)
        ld s5, 56(a1)
    80204cbc:	0385ba83          	ld	s5,56(a1)
        ld s6, 64(a1)
    80204cc0:	0405bb03          	ld	s6,64(a1)
        ld s7, 72(a1)
    80204cc4:	0485bb83          	ld	s7,72(a1)
        ld s8, 80(a1)
    80204cc8:	0505bc03          	ld	s8,80(a1)
        ld s9, 88(a1)
    80204ccc:	0585bc83          	ld	s9,88(a1)
        ld s10, 96(a1)
    80204cd0:	0605bd03          	ld	s10,96(a1)
        ld s11, 104(a1)
    80204cd4:	0685bd83          	ld	s11,104(a1)

    80204cd8:	00008067          	ret
	...
