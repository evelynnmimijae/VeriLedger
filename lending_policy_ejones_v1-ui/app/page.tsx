'use client';
import { useState } from 'react';
import { Shield, Lock, FileCheck, Server, Activity, CheckCircle } from 'lucide-react';

export default function VeriLedgerDashboard() {
  // --- STATE MANAGEMENT ---
  const [step, setStep] = useState<number>(0); // 0:Input, 1:Encrypt, 2:iExec, 3:Aleo, 4:Done
  const [loanAmount, setLoanAmount] = useState<string | number>(50000);
  const [collateral, setCollateral] = useState<string | number>(65000);
  const [logs, setLogs] = useState<string[]>([]);
  const [txHash, setTxHash] = useState<string | null>(null);

  // Helper: Add timestamped logs
  const addLog = (msg: string) => {
    const time = new Date().toLocaleTimeString('en-US', { hour12: false });
    setLogs(prev => [`[${time}] ${msg}`, ...prev]);
  };

  // --- MOCK WORKFLOW ENGINE ---
  const startDemo = () => {
    setStep(1);
    setLogs([]); // Clear previous logs
    addLog("INIT: Starting VeriLedger Secure Loan Request...");
    
    // Step 1: Encryption (Simulated)
    setTimeout(() => {
      addLog("CLIENT: Encrypting sensitive data with iExec Public Key...");
    }, 1000);

    // Step 2: iExec Risk Evaluation
    setTimeout(() => {
      setStep(2);
      addLog("NET: Encrypted payload sent to iExec Worker Enclave.");
    }, 2500);

    setTimeout(() => {
      addLog("TEE: Decrypting data inside secure hardware...");
      addLog("TEE: Running 'app.py' risk model...");
    }, 4000);

    // Step 3: Aleo ZK Proof
    setTimeout(() => {
      setStep(3);
      addLog("TEE: Risk Result: APPROVED (Score: 82/100).");
      addLog("ALEO: Generating Zero-Knowledge Proof of Compliance...");
    }, 7000);

    // Step 4: Final Verification
    setTimeout(() => {
      setStep(4);
      setTxHash("at1...z9y (Simulated)");
      addLog("CHAIN: Proof verified on Aleo Testnet.");
      addLog("SUCCESS: Loan Approved. Smart Contract notified.");
    }, 10000);
  };

  // --- UI COMPONENTS ---
  return (
    <main className="min-h-screen bg-slate-950 text-slate-200 p-6 font-sans selection:bg-blue-500/30">
      
      {/* HEADER */}
      <header className="max-w-6xl mx-auto flex justify-between items-center border-b border-slate-800 pb-6 mb-8">
        <div className="flex items-center gap-3">
          <div className="bg-blue-600 p-2 rounded-lg">
            <Shield className="text-white w-6 h-6" />
          </div>
          <div>
            <h1 className="text-2xl font-bold text-white tracking-tight">VeriLedger</h1>
            <p className="text-slate-500 text-xs uppercase tracking-wider">Privacy-Preserving Lending</p>
          </div>
        </div>
        <div className="flex items-center gap-4 text-sm">
          <div className="flex items-center gap-2 px-3 py-1 rounded-full bg-slate-900 border border-slate-800">
            <div className="w-2 h-2 rounded-full bg-green-500 animate-pulse"></div>
            <span className="text-slate-400">System Online</span>
          </div>
        </div>
      </header>

      <div className="max-w-6xl mx-auto grid grid-cols-1 lg:grid-cols-12 gap-8">
        
        {/* LEFT COLUMN: INPUT FORM */}
        <div className="lg:col-span-4 space-y-6">
          <div className={`p-6 rounded-2xl border transition-all duration-300 ${step === 0 ? 'bg-slate-900 border-blue-500/50 shadow-lg shadow-blue-500/10' : 'bg-slate-900/50 border-slate-800 opacity-60'}`}>
            <h2 className="text-lg font-semibold text-white mb-4 flex items-center gap-2">
              <FileCheck className="w-5 h-5 text-blue-400" />
              Loan Request
            </h2>
            
            <div className="space-y-4">
              <div>
                <label className="block text-xs font-medium text-slate-400 mb-1">Loan Amount (USDC)</label>
                <input 
                  type="number" 
                  value={loanAmount}
                  onChange={(e) => setLoanAmount(e.target.value)}
                  disabled={step > 0}
                  className="w-full bg-slate-950 border border-slate-800 rounded-lg p-3 text-white focus:ring-2 focus:ring-blue-500 outline-none transition"
                />
              </div>
              
              <div>
                <label className="block text-xs font-medium text-slate-400 mb-1">Collateral (ETH)</label>
                <input 
                  type="number" 
                  value={collateral}
                  onChange={(e) => setCollateral(e.target.value)}
                  disabled={step > 0}
                  className="w-full bg-slate-950 border border-slate-800 rounded-lg p-3 text-white focus:ring-2 focus:ring-blue-500 outline-none transition"
                />
              </div>

              <div className="p-3 bg-blue-500/10 border border-blue-500/20 rounded-lg text-xs text-blue-200 flex gap-2">
                <Lock className="w-4 h-4 shrink-0" />
                Data is encrypted client-side. Only the final proof is revealed on-chain.
              </div>

              <button 
                onClick={startDemo}
                disabled={step > 0}
                className="w-full bg-blue-600 hover:bg-blue-500 disabled:bg-slate-700 disabled:cursor-not-allowed text-white font-semibold py-3 rounded-lg transition-all active:scale-[0.98]"
              >
                {step === 0 ? 'Submit Private Request' : 'Processing...'}
              </button>
            </div>
          </div>

          {/* STATUS CARDS */}
          <div className="grid grid-cols-2 gap-4">
             <div className={`p-4 rounded-xl border ${step >= 2 ? 'bg-green-500/10 border-green-500/30' : 'bg-slate-900 border-slate-800'}`}>
                <div className="text-xs text-slate-400 mb-1">Risk Engine</div>
                <div className={`font-mono text-sm ${step >= 2 ? 'text-green-400' : 'text-slate-600'}`}>
                   {step >= 2 ? 'COMPLETED' : 'WAITING'}
                </div>
             </div>
             <div className={`p-4 rounded-xl border ${step >= 4 ? 'bg-green-500/10 border-green-500/30' : 'bg-slate-900 border-slate-800'}`}>
                <div className="text-xs text-slate-400 mb-1">Final Decision</div>
                <div className={`font-mono text-sm ${step >= 4 ? 'text-green-400' : 'text-slate-600'}`}>
                   {step >= 4 ? 'APPROVED' : 'PENDING'}
                </div>
             </div>
          </div>
        </div>

        {/* RIGHT COLUMN: VISUALIZATION */}
        <div className="lg:col-span-8 space-y-6">
          
          {/* PIPELINE VISUALIZER */}
          <div className="bg-slate-900 rounded-2xl border border-slate-800 p-8 relative overflow-hidden">
             <div className="absolute top-0 right-0 p-4 opacity-10">
                <Server className="w-32 h-32" />
             </div>
             
             <div className="flex justify-between items-center relative z-10">
                {/* Step 1 Node */}
                <div className={`flex flex-col items-center gap-3 transition-opacity duration-500 ${step >= 1 ? 'opacity-100' : 'opacity-40'}`}>
                   <div className={`w-12 h-12 rounded-full flex items-center justify-center border-2 ${step >= 1 ? 'bg-blue-500 border-blue-400 shadow-[0_0_20px_rgba(59,130,246,0.5)]' : 'bg-slate-800 border-slate-700'}`}>
                      <Lock className="w-5 h-5 text-white" />
                   </div>
                   <span className="text-xs font-semibold tracking-wider">ENCRYPT</span>
                </div>

                {/* Connector Line */}
                <div className={`h-0.5 flex-1 mx-4 transition-colors duration-1000 ${step >= 2 ? 'bg-blue-500' : 'bg-slate-800'}`}></div>

                {/* Step 2 Node */}
                <div className={`flex flex-col items-center gap-3 transition-opacity duration-500 ${step >= 2 ? 'opacity-100' : 'opacity-40'}`}>
                   <div className={`w-12 h-12 rounded-full flex items-center justify-center border-2 ${step >= 2 ? 'bg-yellow-500 border-yellow-400 shadow-[0_0_20px_rgba(234,179,8,0.5)]' : 'bg-slate-800 border-slate-700'}`}>
                      <Activity className="w-5 h-5 text-white" />
                   </div>
                   <span className="text-xs font-semibold tracking-wider">iEXEC TEE</span>
                </div>

                {/* Connector Line */}
                <div className={`h-0.5 flex-1 mx-4 transition-colors duration-1000 ${step >= 3 ? 'bg-blue-500' : 'bg-slate-800'}`}></div>

                {/* Step 3 Node */}
                <div className={`flex flex-col items-center gap-3 transition-opacity duration-500 ${step >= 3 ? 'opacity-100' : 'opacity-40'}`}>
                   <div className={`w-12 h-12 rounded-full flex items-center justify-center border-2 ${step >= 3 ? 'bg-purple-500 border-purple-400 shadow-[0_0_20px_rgba(168,85,247,0.5)]' : 'bg-slate-800 border-slate-700'}`}>
                      <Shield className="w-5 h-5 text-white" />
                   </div>
                   <span className="text-xs font-semibold tracking-wider">ALEO PROOF</span>
                </div>

                 {/* Connector Line */}
                <div className={`h-0.5 flex-1 mx-4 transition-colors duration-1000 ${step >= 4 ? 'bg-blue-500' : 'bg-slate-800'}`}></div>

                {/* Step 4 Node */}
                <div className={`flex flex-col items-center gap-3 transition-opacity duration-500 ${step >= 4 ? 'opacity-100' : 'opacity-40'}`}>
                   <div className={`w-12 h-12 rounded-full flex items-center justify-center border-2 ${step >= 4 ? 'bg-green-500 border-green-400 shadow-[0_0_20px_rgba(34,197,94,0.5)]' : 'bg-slate-800 border-slate-700'}`}>
                      <CheckCircle className="w-5 h-5 text-white" />
                   </div>
                   <span className="text-xs font-semibold tracking-wider">VERIFIED</span>
                </div>
             </div>
          </div>

          {/* LIVE CONSOLE */}
          <div className="bg-black rounded-xl border border-slate-800 overflow-hidden flex flex-col h-64 shadow-2xl">
            <div className="bg-slate-900 px-4 py-2 border-b border-slate-800 flex items-center gap-2">
               <div className="w-2 h-2 rounded-full bg-red-500"></div>
               <div className="w-2 h-2 rounded-full bg-yellow-500"></div>
               <div className="w-2 h-2 rounded-full bg-green-500"></div>
               <span className="ml-2 text-xs text-slate-400 font-mono">veriledger-node ~ Live Logs</span>
            </div>
            <div className="p-4 font-mono text-xs overflow-y-auto flex-1 space-y-1">
               {logs.length === 0 && <span className="text-slate-600 animate-pulse">Waiting for transaction...</span>}
               {logs.map((log, i) => (
                  <div key={i} className="text-green-400 border-l-2 border-transparent hover:border-slate-700 pl-2">
                     <span className="opacity-50 mr-2">{log.split(']')[0]}]</span>
                     {log.split(']')[1]}
                  </div>
               ))}
               {step === 4 && (
                  <div className="mt-4 pt-4 border-t border-slate-800 text-blue-300">
                     <span className="text-slate-500">Transaction ID:</span> {txHash}
                     <br/>
                     <span className="text-slate-500">Status:</span> <span className="bg-green-500/20 text-green-400 px-1 rounded">CONFIRMED</span>
                  </div>
               )}
            </div>
          </div>

        </div>
      </div>
    </main>
  );
}