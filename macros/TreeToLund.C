/**
* Description: Convert a ROOT TTree to Lund format.
* Author: Matthew F. McEneaney
* Date: 16 September 2025
*/

float getCharge(int pid) {
    switch (pid) {

        // Lund particles
        case 91:  // Lund string
            return 0;
        case 92:  // Lund cluster
            return 0;

        /*
        
        DIQUARKS
        (dd)1 1103
        (ud)0 2101
        (ud)1 2103
        (uu)1 2203
        (sd)0 3101
        (sd)1 3103
        (su)0 3201
        (su)1 3203
        (ss)1 3303
        
        */

        // Diquarks // Just set to 0 charge for now
        case 1103: // dd_1 diquark -2/3
            return 0;
        case 2101: // ud_0 diquark 1/3
            return 0;
        case 2103: // ud_1 diquark 1/3
            return 0;
        case 2203: // uu_1 diquark 4/3
            return 0;
        case 3101: // sd_0 diquark -2/3
            return 0;
        case 3103: // sd_1 diquark -2/3
            return 0;
        case 3201: // su_0 diquark 1/3
            return 0;
        case 3203: // su_1 diquark 1/3
            return 0;
        case 3303: // ss_1 diquark -2/3
            return 0;

        // Leptons
        case 11:   // electron
            return -1;
        case -11:  // positron
            return 1;
        case 13:   // muon-
            return -1;
        case -13:  // muon+
            return 1;

        // Bosons
        case 21:   // gluon
            return 0;
        case 22:   // photon
            return 0;

        // Light I=1 Mesons
        case 111:  // pi0
            return 0;
        case -111: // anti-pi0
            return 0;
        case 211:  // pi+
            return 1;
        case -211: // pi-
            return -1;
        case 213:  // rho+
            return 1;
        case -213: // rho-
            return -1;
        case 113:  // rho0
            return 0;
        case -113: // anti-rho0
            return 0;

        // Light I=0 Mesons
        case 221:  // eta
            return 0;
        case 331:  // eta'
            return 0;
        case 223:  // omega
            return 0;
        case 333:  // phi
            return 0;
        
        // Strange Mesons
        case 130:  // K0_L
            return 0;
        case 310:  // K0_S
            return 0;
        case 311:  // K0
            return 0;
        case -311: // anti-K0
            return 0;
        case 321:  // K+
            return 1;
        case -321: // K-
            return -1;
        case 313:  // K*0
            return 0;
        case -313: // anti-K*0
            return 0;
        case 323:  // K*+
            return 1;
        case -323: // K*-
            return -1;

        // Light Baryons
        case 2212: // proton
            return 1;
        case -2212:// anti-proton
            return -1;
        case 2112: // neutron
            return 0;
        case -2112:// anti-neutron
            return 0;
        case 2208: // Delta++
            return 2;
        case -2208:// anti-Delta++
            return -2;
        case 2214: // Delta+
            return 1;
        case -2214:// anti-Delta+
            return -1;
        case 2224: // Delta0
            return 0;
        case -2224:// anti-Delta0
            return 0;
        case 2234: // Delta-
            return -1;
        case -2234:// anti-Delta-
            return 1;

        // Strange Baryons
        case 3122: // Lambda
            return 0;
        case -3122:// anti-Lambda
            return 0;
        case 3222: // Sigma+
            return 1;
        case -3222:// anti-Sigma+
            return -1;
        case 3212: // Sigma0
            return 0;
        case -3212:// anti-Sigma0
            return 0;
        case 3112: // Sigma-
            return -1;
        case -3112:// anti-Sigma-
            return 1;
        case 3322: // Xi0
            return 0;
        case -3322:// anti-Xi0
            return 0;
        case 3312: // Xi-
            return -1;
        case -3312:// anti-Xi-
            return 1;
        case 3334: // Omega-
            return -1;
        case -3334:// anti-Omega-
            return 1;

        // Default
        default:
            return 0; // neutral or unknown
    }
}

void writeLundEvent(std::ofstream &out,
                    std::map<int, std::tuple<int, int, int, int, double, double, double, double>> particleMap, // key: particle index[0:nParticles], value: (status, pid, mother, daughter, px, py, pz, E)
                    int nTargetNucleons = 1, // assuming hydrogen target
                    int nTargetProtons = 1,  // assuming hydrogen target
                    float targetPol = 0,       // unpolarized target
                    float beamPol = 1,         // assuming positive helicity
                    int beamPid = 11,        // beam particle id
                    float beamEnergy = 10.6, // GeV
                    int targetPid = 2212,    // proton
                    int processId = 1,       // assuming DIS
                    float integratedXS = 0.0, // not provided
                    std::string delimiter = " ",
                    int precision = 5
                ) {

    // Get number of particles
    int nparticles = particleMap.size()+1;

    // Write event header
    // nparticles, nTargetNucleons(PARL1), nTargetProtons(PARL2),
    // targetPol, beamPol
    // beamPid, beamEnergy, targetPid, processId, integratedXS(PARL23)
    out << std::fixed << std::setprecision(precision) 
        << nparticles << delimiter.c_str()
        << nTargetNucleons << delimiter.c_str() << nTargetProtons << delimiter.c_str() 
        << targetPol << delimiter.c_str() << beamPol << delimiter.c_str()
        << beamPid << delimiter.c_str() << beamEnergy << delimiter.c_str()
        << targetPid << delimiter.c_str() << processId << delimiter.c_str()
        << integratedXS << std::endl;

    //----- Manually insert virtual photon from incoming and scattered electrons -----//

    // Grab incoming electron
    auto &tup_e_0 = particleMap[0];
    double px_e_0 = std::get<4>(tup_e_0);
    double py_e_0 = std::get<5>(tup_e_0);
    double pz_e_0 = std::get<6>(tup_e_0);
    double E_e_0  = std::get<7>(tup_e_0);

    // Grab outgoing electron
    auto &tup_e_3 = particleMap[3];
    double px_e_3 = std::get<4>(tup_e_3);
    double py_e_3 = std::get<5>(tup_e_3);
    double pz_e_3 = std::get<6>(tup_e_3);
    double E_e_3  = std::get<7>(tup_e_3);

    // Set virtual photon with momentum and energy conservation
    int status_ph    = 21;
    int pid_ph       = 22;
    int mother_ph    = 1;
    int daughter_ph  = 4;
    double px_ph     = px_e_0-px_e_3;
    double py_ph     = py_e_0-py_e_3;
    double pz_ph     = pz_e_0-pz_e_3;
    double E_ph      = E_e_0-E_e_3;

    particleMap[2] = std::make_tuple(status_ph, pid_ph, mother_ph, daughter_ph, px_ph, py_ph, pz_ph, E_ph);

    // Loop over particles
    for (int j = 0; j < nparticles; ++j) {

        // Set particle data
        auto& tup = particleMap[j];
        // //NOTE: ASSUME FIRST ENTRIES ARE:
        // - INITIAL ELECTRON, 
        // - TARGET PROTON,
        // - VIRTUAL PHOTON, 
        // - SCATTERED ELECTRON, 
        // - REMAINING PARTICLES...
        int pid = std::get<1>(tup);
        int mother = std::get<2>(tup);
        int daughter = std::get<3>(tup);
        int status = (daughter>0) ? 1 : 21; //NOTE: Final state particles have no daughters.
        double px = std::get<4>(tup);
        double py = std::get<5>(tup);
        double pz = std::get<6>(tup);
        double E = std::get<7>(tup);

        // Compute mass and set vertices and get charge
        float charge = getCharge(pid);
        float m2 = E*E - (px*px + py*py + pz*pz);
        float m = (m2 > 0) ? sqrt(m2) : sqrt(-m2);
        float vx = 0.0, vy = 0.0, vz = 0.0; //NOTE: DO NOT RASTER FOR NOW

        // Write particle data
        out << std::fixed << std::setprecision(precision)
            << j+1 << delimiter.c_str() //IMPORTANT: Lund index starts at 1!
            << charge << delimiter.c_str()
            << status << delimiter.c_str() << pid << delimiter.c_str()
            << mother << delimiter.c_str()
            << daughter << delimiter.c_str()
            << px << delimiter.c_str() << py << delimiter.c_str() << pz << delimiter.c_str()
            << E << delimiter.c_str() << m << delimiter.c_str()
            << vx << delimiter.c_str() << vy << delimiter.c_str() << vz
            << std::endl;
    }

    return;
}

void TreeToLund(const char* filename = "/Users/mfm45/Downloads/Tree-ep-at-JLAB12-posHelicity.root",
                const char* treename = "tree",
                const char* outname = "output.lund",
                int MCIndex = 0, // not used
                int maxEvents = 10000, // not used
                int nTargetNucleons = 1, // assuming hydrogen target
                int nTargetProtons = 1,  // assuming hydrogen target
                float targetPol = 0,       // unpolarized target
                float beamPol = 1,         // assuming positive helicity
                int beamPid = 11,        // beam particle id
                float beamEnergy = 10.6, // GeV
                int targetPid = 2212,    // proton
                int processId = 1        // assuming DIS
            ) {

    // Open input file and get TTree
    TFile* file = TFile::Open(filename);
    if (!file || file->IsZombie()) {
        std::cerr << "Cannot open input file!" << std::endl;
        return;
    }

    // Open TTree
    TTree* tree = (TTree*)file->Get(treename);
    if (!tree) {
        std::cerr << "Tree not found!" << std::endl;
        return;
    }

    // Set branches
    Int_t iEvent, iPos, status, pid, mother, daughter;
    Double_t px, py, pz, E;

    // Set branch addresses
    tree->SetBranchAddress("iEvent", &iEvent);
    tree->SetBranchAddress("iPos", &iPos);
    tree->SetBranchAddress("status", &status);
    tree->SetBranchAddress("id", &pid);
    tree->SetBranchAddress("iMother1", &mother);
    tree->SetBranchAddress("iDaughter1", &daughter);
    tree->SetBranchAddress("Px", &px);
    tree->SetBranchAddress("Py", &py);
    tree->SetBranchAddress("Pz", &pz);
    tree->SetBranchAddress("E", &E);

    // Open output file
    std::ofstream out(outname);
    if (!out.is_open()) {
        std::cerr << "Failed to open output file!" << std::endl;
        return;
    }

    // Initialize looping variables
    Long64_t nentries = tree->GetEntries();
    Int_t currentEvent = -1;
    std::map<int, std::tuple<int, int, int, int, double, double, double, double>> particleMap;

    // Loop TTree
    int eventCounter = 0;
    int pcounter = 0;
    for (Long64_t i = 0; i < nentries; ++i) {
        tree->GetEntry(i);

        // Assume events are grouped by iEvent in the TTree
        if (iEvent != currentEvent && currentEvent != -1) {

            eventCounter++;

            // Check if minimum event number has been reached
            if (eventCounter > maxEvents*MCIndex) {

                // Write previous event
                writeLundEvent(
                    out,
                    particleMap,
                    nTargetNucleons, // nTargetNucleons
                    nTargetProtons, // nTargetProtons
                    targetPol, // targetPol (unpolarized)
                    beamPol, // beamPol (positive helicity)
                    beamPid, // beamPid (electron)
                    beamEnergy, // beamEnergy (GeV)
                    targetPid, // targetPid (proton)
                    processId, // processId (DIS)
                    0.0, // integratedXS
                    "\t", // delimiter
                    5 // precision
                );

                // Clear for next event
                particleMap.clear();
                pcounter = 0;

            }
            
        }

        // Set event number
        currentEvent = iEvent;

        // Check if minimum index has been reached
        if (eventCounter >= maxEvents*MCIndex) {

            // Manually skip virtual photon index since not present in trees
            if (pcounter==2) {
                pcounter++;
            }

            // Store particle data by iPos (particle index: 1, 2, 5, ...)
            particleMap[pcounter++] = std::make_tuple(status, pid, mother, daughter, px, py, pz, E);

        // Break if maximum number of events for this MCIndex has been reached   
        } else if (eventCounter >= maxEvents*(MCIndex+1)) {
            
            break;
        }
    }

    // Write last event
    if (!particleMap.empty()) {
        writeLundEvent(out, particleMap);
    }

    // Close files
    out.close();
    file->Close();
    std::cout << "Lund file written to: " << outname << std::endl;
}
