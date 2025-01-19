import os
import pandas as pd

workspace_dir = "/workspaces/cs251a"
results_dir = os.path.join(workspace_dir, "hw1/results")
stat_file = "stats.txt"
benchmarks = ["lfsr", "merge", "mm", "sieve", "spmv"]
configs = ["4GHz", "16MiB_l2_cache", "256KiB_l2_cache", "default", "issueWidth2", "no_l2_cache", "O1_compiler", "x86MinorCPU"]

def main():
    all_data = parse_stat_files()
    # print(all_data.xs("issueWidth2", level="config"))
    print(all_data)
    
    compare_stat(stat_name="hostInstRate", data_source=all_data)
    compare_stat(stat_name="system.cpu.ipc", data_source=all_data)


def compare_stat(stat_name, data_source: pd.DataFrame):
    df : pd.DataFrame = data_source[stat_name]
    print(df)
    
    ax = df.unstack().plot.bar(
        ylabel=stat_name, 
        title=f"{stat_name}", 
        width=0.75, 
        rot=0,
        figsize=(10, 10)
    )
    ax.figure.savefig(f'hw1/figures/{stat_name}.png')


def parse_stat_files():
    stats_per_benchmark = {}
    for benchmark in benchmarks:
        stats_per_config = {}
        for config in configs:
            stat_path = os.path.join(results_dir, benchmark, config, stat_file)
            df = stat_file_to_dataframe(stat_path)
            stats_per_config[config] = df
        df = pd.concat(stats_per_config, axis=1)
        df.columns = df.columns.droplevel(1)
        stats_per_benchmark[benchmark] = df
        
    df = pd.concat(stats_per_benchmark, axis=1).T
    df.index.set_names(["benchmark", "config"], inplace=True)
    
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