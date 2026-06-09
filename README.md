# VHDL Quantum Hadamard Gate ⚛️

Implementazione hardware (RTL) di un operatore quantistico di Hadamard per un singolo qubit, sviluppato in VHDL per target FPGA Xilinx Spartan-7 (Boolean Board).

Questo progetto è stato realizzato come elaborato per il corso di *Introduzione al trattamento quantistico dei dati* del corso di Laurea Magistrale in Ingegneria Informatica e Intelligenza Artificiale Applicata (LM-32) presso l'Università Telematica San Raffaele Roma.

## 📌 Descrizione del Progetto

Il Gate di Hadamard è una porta quantistica fondamentale che crea una sovrapposizione equa di stati. L'operazione trasforma lo stato di ingresso moltiplicando le ampiezze di probabilità per la seguente matrice unitaria:

$$H = \frac{1}{\sqrt{2}} \begin{pmatrix} 1 & 1 \\ 1 & -1 \end{pmatrix}$$

Per mappare questa operazione nel dominio digitale, il design adotta un'aritmetica **Fixed-Point** con una word length di 12 bit con segno (formato Q3.8). La costante $1/\sqrt{2}$ è stata quantizzata al valore intero di `181` ($0.7071 \times 2^8$), garantendo un errore di quantizzazione trascurabile ($\approx 0.000075$).

## 🚀 Caratteristiche Tecniche e Architettura

* **Linguaggio:** VHDL (IEEE 1164, Numeric_Std)
* **Aritmetica:** Fixed-Point Q3.8 (1 bit segno, 3 bit interi, 8 bit frazionari)
* **Sincronizzazione I/O:** Registri di campionamento in ingresso e in uscita per garantire un datapath stabile (Latenza: 2 cicli di clock).
* **DSP Register Absorption:** Ottimizzazione avanzata in fase di sintesi che assorbe i registri di input direttamente all'interno dei macro-blocchi DSP48E1, riducendo l'impiego di Slice Registers generici.

## 🛠️ Hardware e Strumenti

* **Target Board:** Boolean Board
* **FPGA:** Xilinx Spartan-7 (`xc7s50csga324-1`)
* **EDA Tool:** Xilinx Vivado

## 📊 Risultati di Implementazione (Synthesis & Place/Route)

Il design si distingue per un'impronta hardware estremamente leggera e per performance temporali elevate, ideali per essere integrate in circuiti quantistici (o emulatori) più complessi.

* **Frequenza Massima Operativa ($F_{max}$):** 120.6 MHz (WNS: 1.710 ns su clock di 10ns)
* **Dissipazione di Potenza (On-Chip):** 0.078 W (prevalentemente statica)

**Utilizzo Risorse:**

| Risorsa | Quantità | % Utilizzo | Note |
| --- | --- | --- | --- |
| **Slice LUTs** | 13 | 0.04% | Somme/sottrazioni incrociate |
| **Slice Registers** | 25 | 0.04% | Sincronizzazione datapath |
| **DSPs** | 3 | 2.50% | DSP48E1 per moltiplicazione matriciale |
| **Bonded IOB** | 50 | 23.81% | Interfaccia I/O a 24 bit |

## 🧪 Validazione e Test-bench

Il progetto include una suite di simulazione *behavioral* (`tb_hadamard.vhd`) che inietta 4 configurazioni di stato quantistico per validare l'unitarietà e la reversibilità dell'operatore:

1. **$|0\rangle \to |+\rangle$:** Input `(256, 0)` $\rightarrow$ Output `(181, 181)`
2. **$|1\rangle \to |-\rangle$:** Input `(0, 256)` $\rightarrow$ Output `(181, -181)`
3. **$|+\rangle \to |0\rangle$:** Reversibilità validata, output collassa verso lo stato base `(256, 0)`
4. **$|-\rangle \to |1\rangle$:** Reversibilità validata, output collassa verso lo stato base `(0, 256)`

*(Nota: I valori `256` e `181` rappresentano rispettivamente i valori floating point $1.0$ e $1/\sqrt{2}$ scalati nel formato intero Q3.8).*

## 📂 Struttura della Repository

* `/src`: Contiene il file sorgente RTL `hadamard_top.vhd`
* `/sim`: Contiene il file di test-bench `tb_hadamard.vhd` per la simulazione
* `/docs`: Report dettagliato dell'implementazione in PDF

---
