import subprocess

def test_help_message():
    result = subprocess.run(
        ["python", "tools/update_server_headers.py", "--help"],
        capture_output=True, text=True
    )
    assert result.returncode == 0
    assert "usage" in result.stdout.lower()
