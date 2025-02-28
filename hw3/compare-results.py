import os
import pandas as pd

workspace_dir = "/workspaces/cs251a" # Maxwell's setup
# workspace_dir = "/root/cs251a" # Saim's setup
results_dir = os.path.join(workspace_dir, "hw3/test_results")
stat_file = "m5out/stats.txt"
policies = os.listdir(results_dir)
benchmarks = os.listdir(os.path.join(results_dir, policies[0]))
configs = os.listdir(os.path.join(results_dir, policies[0], benchmarks[0]))

def main():
    all_data = parse_stat_files()
    # print(all_data.xs("issueWidth2", level="config"))
    print(all_data)
    
    for c in configs:
        for stat in ["system.switch_cpus.ipc", 
                     "system.cpu.dcache.demandMissRate::total", 
                     "system.cpu.dcache.demandAvgMissLatency::total"]:
            compare_stat(stat_name=stat, name=c, data_source=all_data)


def compare_stat(stat_name, name, data_source: pd.DataFrame):
    df : pd.DataFrame = data_source[stat_name].xs(name, level=2).unstack().T
    print(df)
    
    ax = df.plot.bar(
        ylabel=stat_name, 
        title=f"{stat_name}", 
        width=0.75, 
        rot=0,
        figsize=(10, 10)
    )
    folder = f'{workspace_dir}/hw3/figures/{name}'
    if not os.path.exists(folder): os.makedirs(folder)
    ax.figure.savefig(f'{folder}/{stat_name}.png')


def parse_stat_files():
    stats_per_policy = {}
    for policy in policies:
        stats_per_benchmark = {}
        for benchmark in benchmarks:
            stats_per_config = {}
            for config in configs:
                stat_path = os.path.join(results_dir, policy, benchmark, config, stat_file)
                df = stat_file_to_dataframe(stat_path)
                stats_per_config[config] = df
            df = pd.concat(stats_per_config, axis=1)
            df.columns = df.columns.droplevel(1)
            stats_per_benchmark[benchmark] = df
        df = pd.concat(stats_per_benchmark, axis=1)
        stats_per_policy[policy] = df
        
    df = pd.concat(stats_per_policy, axis=1).T
    df.index.set_names(["policy", "benchmark", "config"], inplace=True)
    
    return df


def stat_file_to_dataframe(stat_path) -> pd.DataFrame:
    try:
        df = pd.read_table(stat_path, comment="#", skiprows=1, skipfooter=1, engine="python")
    except pd.errors.EmptyDataError as e:
        print(f"Failed to parse {stat_path}")
        return
    
    df = df[df.columns[0]].str.strip().str.split(expand=True).iloc[:, :2]
    df.columns = ["metric", "value"]
    df.set_index("metric", inplace=True)
    df["value"] = pd.to_numeric(df["value"], errors="coerce")
    
    return df


if __name__ == "__main__":
    main()