import os
import sys
import zipfile
import tarfile
import shutil
from pathlib import Path

CHECKS = {
    # --- USER CONTROLLERS ---
    "app/Http/Controllers/Api/Application/Users/UserController.php": [
        "public function delete(DeleteUserRequest",
        "public function update(UpdateUserRequest",
        "public function store(StoreUserRequest"
    ],
    "app/Http/Controllers/Admin/UserController.php": [
        "public function delete(Request",
        "public function update(UserFormRequest",
        "public function store(NewUserFormRequest"
    ],

    # --- SERVER & BUILD SERVICES ---
    "app/Services/Servers/BuildModificationService.php": [
        "public function handle(Server $server, array $data): Server"
    ],
    "app/Services/Servers/DetailsModificationService.php": [
        "return $this->connection->transaction(function () use ($data, $server) {"
    ],

    # --- SERVER CONTROLLERS ---
    "app/Http/Controllers/Api/Application/Servers/ServerController.php": [
        "public function delete(ServerWriteRequest"
    ],
    "app/Http/Controllers/Api/Application/Servers/ServerManagementController.php": [
        "public function suspend(ServerWriteRequest",
        "public function reinstall(ServerWriteRequest"
    ],
    "app/Http/Controllers/Api/Application/Servers/StartupController.php": [
        "public function index(UpdateServerStartupRequest"
    ],
    "app/Http/Controllers/Admin/ServersController.php": [
        "public function delete(Request",
        "public function manageSuspension(Request",
        "public function toggleInstall(Server",
        "public function reinstallServer(Server",
        "public function saveStartup(Request"
    ],
    "app/Http/Controllers/Admin/Servers/ServerTransferController.php": [
        "public function transfer(Request"
    ],
    
    # --- CLIENT API CONTROLLERS ---
    "app/Http/Controllers/Api/Client/Servers/ServerController.php": [
        "public function index(GetServerRequest" 
    ],
    "app/Http/Controllers/Api/Client/TwoFactorController.php": [
        "public function index(Request",
        "public function store(Request"
    ],
    "app/Http/Controllers/Api/Client/Servers/FileController.php": [
        "public function directory(ListFilesRequest",
        "public function contents(GetFileContentsRequest",
        "public function download(GetFileContentsRequest",
        "public function pull(PullFileRequest",
        "public function write(WriteFileContentRequest",
        "public function rename(RenameFileRequest",
        "public function delete(DeleteFileRequest",
        "public function decompress(DecompressFilesRequest"
    ],
    "app/Http/Controllers/Api/Client/Servers/SettingsController.php": [
        "public function reinstall(ReinstallServerRequest"
    ],

    # --- SETTINGS & LOCATIONS ---
    "app/Http/Controllers/Admin/Settings/IndexController.php": ["public function update(BaseSettingsFormRequest"],
    "app/Http/Controllers/Admin/Settings/AdvancedController.php": ["public function update(AdvancedSettingsFormRequest"],
    "app/Http/Controllers/Admin/Settings/MailController.php": ["public function update(MailSettingsFormRequest"],
    
    # --- DATABASE & MOUNT ---
    "app/Http/Controllers/Admin/DatabaseController.php": [
        "public function create(DatabaseHostFormRequest",
        "public function update(DatabaseHostFormRequest",
        "public function delete(int $host)"
    ],
    "app/Http/Controllers/Admin/MountController.php": [
        "public function create(MountFormRequest",
        "public function update(MountFormRequest",
        "public function delete(Mount",
        "public function addEggs(Request",
        "public function addNodes(Request",
        "public function deleteEgg(Mount",
        "public function deleteNode(Mount"
    ],

    # --- LOCATIONS ---
    "app/Http/Controllers/Admin/LocationController.php": [
        "public function view(int $id)",
        "public function create(LocationFormRequest",
        "public function update(LocationFormRequest",
        "public function delete(Location"
    ],
    "app/Http/Controllers/Api/Application/Locations/LocationController.php": [
        "public function store(StoreLocationRequest",
        "public function update(UpdateLocationRequest",
        "public function delete(DeleteLocationRequest"
    ],

    # --- NODES ---
    "app/Http/Controllers/Admin/NodesController.php": [
        "public function store(NodeFormRequest",
        "public function updateSettings(NodeFormRequest",
        "public function delete(int|Node"
    ],
    "app/Http/Controllers/Admin/Nodes/NodeViewController.php": [
        "public function settings(Request",
        "public function configuration(Request"
    ],
    "app/Http/Controllers/Api/Application/Nodes/NodeController.php": [
        "public function store(StoreNodeRequest",
        "public function update(UpdateNodeRequest",
        "public function delete(DeleteNodeRequest"
    ],

    # --- NESTS & EGGS ---
    "app/Http/Controllers/Admin/Nests/NestController.php": [
        "public function store(StoreNestFormRequest",
        "public function update(StoreNestFormRequest",
        "public function destroy(int $nest)"
    ],
    "app/Http/Controllers/Admin/Nests/EggController.php": [
        "public function store(EggFormRequest",
        "public function update(EggFormRequest",
        "public function destroy(Egg"
    ],
    "app/Http/Controllers/Admin/Nests/EggScriptController.php": [
        "public function update(EggScriptFormRequest"
    ],
    "app/Http/Controllers/Admin/Nests/EggShareController.php": [
        "public function export(Egg",
        "public function update(EggImportFormRequest"
    ],
    "app/Http/Controllers/Admin/Nests/EggVariableController.php": [
        "public function store(EggVariableFormRequest",
        "public function update(EggVariableFormRequest",
        "public function destroy(int $egg, EggVariable $variable)"
    ]
}

SUPPORTED_ARCHIVES = {".zip", ".tar", ".gz", ".tgz"}
BASE_DIR = Path.cwd()

def extract_archive(archive_path: Path) -> Path:
    extract_dir = BASE_DIR / f"_temp_check_{archive_path.stem}"
    if extract_dir.exists():
        shutil.rmtree(extract_dir)
    extract_dir.mkdir(exist_ok=True)

    print(f"\n[INFO] Mengekstrak arsip: {archive_path.name}...")
    try:
        if archive_path.suffix == ".zip":
            with zipfile.ZipFile(archive_path, 'r') as z:
                z.extractall(extract_dir)
        else:
            with tarfile.open(archive_path, 'r:*') as t:
                t.extractall(extract_dir)
    except Exception as e:
        print(f"[ERROR] Gagal ekstrak: {e}")
        sys.exit(1)

    for root, dirs, files in os.walk(extract_dir):
        if "app" in dirs and "public" in dirs:
            return Path(root)
    
    return extract_dir

def check_file_content(file_path: Path, patterns: list) -> dict:
    results = {"missing_patterns": [], "found": True}
    
    try:
        with open(file_path, "r", encoding="utf-8", errors="ignore") as f:
            content = f.read()
            
        for pattern in patterns:
            if pattern not in content:
                results["missing_patterns"].append(pattern)
                
    except Exception as e:
        results["found"] = False
        results["error"] = str(e)
        
    return results

def main():
    print("=== VALIDATOR OTOMATIS SCRIPT PROTEKSI FreeZeeHost ===")
    print("Script ini akan mencocokkan target file & kode injeksi")
    print("dengan source code Pterodactyl target.\n")

    path_input = input("Masukkan path file (.zip) atau folder Pterodactyl: ").strip()
    target_path = Path(path_input)

    if not target_path.exists():
        print("[ERROR] Path tidak ditemukan!")
        return

    work_dir = target_path
    is_temp = False

    if any(target_path.name.lower().endswith(ext) for ext in SUPPORTED_ARCHIVES):
        work_dir = extract_archive(target_path)
        is_temp = True

    print(f"[INFO] Memulai pemindaian pada: {work_dir}\n")

    total_files = 0
    missing_files = []
    pattern_mismatches = []
    perfect_matches = 0

    print(f"{'STATUS':<10} | {'FILE / MESSAGE'}")
    print("-" * 80)

    for rel_path, patterns in CHECKS.items():
        total_files += 1
        full_path = work_dir / rel_path
        
        if not full_path.exists():
            print(f"[\033[91mMISSING\033[0m]  | {rel_path}")
            missing_files.append(rel_path)
            continue

        check = check_file_content(full_path, patterns)
        
        if not check["found"]:
            print(f"[\033[91mERROR\033[0m]    | Gagal membaca {rel_path}")
            continue

        if check["missing_patterns"]:
            print(f"[\033[93mWARNING\033[0m]  | {rel_path}")
            for mp in check["missing_patterns"]:
                print(f"           ↳ \033[91mPattern tidak ditemukan:\033[0m {mp}")
                pattern_mismatches.append(f"{rel_path} -> {mp}")
        else:
            print(f"[\033[92mOK\033[0m]       | {rel_path}")
            perfect_matches += 1

    print("-" * 80)
    print("\n=== RINGKASAN HASIL SCAN ===")
    print(f"Total File Target : {total_files}")
    print(f"File Ditemukan    : {perfect_matches} (Aman)")
    print(f"File Hilang       : {len(missing_files)} \033[91m(Kritis)\033[0m")
    print(f"Pattern Berubah   : {len(pattern_mismatches)} \033[93m(Perlu Update Script)\033[0m")

    if missing_files:
        print("\n\033[91m[!] FILE BERIKUT HILANG/DIPINDAHKAN:\033[0m")
        for f in missing_files: print(f" - {f}")

    if pattern_mismatches:
        print("\n\033[93m[!] KODE ASLI BERIKUT BERUBAH (PATTERN TIDAK COCOK):\033[0m")
        for m in pattern_mismatches: print(f" - {m}")
        print("\n\033[96mSARAN:\033[0m Cek file tersebut manual. Kemungkinan developer Pterodactyl")
        print("mengubah argumen function atau nama variabelnya.")

    if is_temp:
        shutil.rmtree(work_dir.parent if work_dir.name == "app" else work_dir)
        print("\n[INFO] File sementara telah dibersihkan.")

if __name__ == "__main__":
    main()
