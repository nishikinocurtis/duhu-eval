import benchmarking
import argparse
import warnings

from benchmarking.tpch.main import run_all_benchmarks

import benchmarking.tpch

NUM_TPCH_QUESTIONS = 22

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--parquet_folder",
        default="/tmp/tpch/parquet",
        help="Path to root folder (local or in S3) containing cached Parquet files",
    )
    parser.add_argument("--scale_factor", 
                        default=10.0, 
                        help="Scale factor to run on in GB", 
                        type=float)
    parser.add_argument("--questions", 
                        type=str, 
                        default=None, 
                        help="Comma-separated list of questions to run, if None then run all")
    parser.add_argument("--output_csv", default=None, type=str, help="Location to output CSV file")
    parser.add_argument(
        "--skip_warmup",
        action="store_true",
        help="Skip warming up data before benchmark",
    )
    parser.add_argument(
        "--ray_job_dashboard_url",
        default="http://localhost:8265",
        type=str,
        help="Ray Dashboard URL to submit jobs instead of using Ray client, most useful when running on a remote cluster",
    )

    args = parser.parse_args()
    parquet_folder = args.parquet_folder

    # if args.skip_warmup:
    #     warnings.warn("Detected --skip_warmup flag, skipping warm up task")
    # else:
    #     benchmarking.tpch.__main__.warmup_environment(args.requirements, parquet_folder)

    if args.questions is not None:
        questions = sorted(set(int(s) for s in args.questions.split(",")))
    else:
        questions = list(range(1, NUM_TPCH_QUESTIONS + 1))

    run_all_benchmarks(
        parquet_folder,
        questions=questions,
        csv_output_location=args.output_csv,
        ray_job_dashboard_url=args.ray_job_dashboard_url,
    )

