pragma circom 2.0.0;

// [assignment] Modify the circuit below to perform a multiplication of three signals

template Multiplier2 () {  

   // Declaration of signals.  
   signal input a;  
   signal input b;  
   signal output c;  

   // Constraints.  
   c <== a * b;  
}

template Multiplier3 () {  

   // Declaration of signals.  
   signal input a;  
   signal input b;
   signal input c;
   signal output d; 

   component G1 =  Multiplier2();

   G1.a <== a;
   G1.b <== b;

   // Constraints.  
   d <== G1.c * c;  
}

component main = Multiplier3();