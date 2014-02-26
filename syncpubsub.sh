echo "Starting subscribers..."
for ((a=0; a<10; a++)); do
    python syncsub.py &
done
echo "Starting publisher..."
python syncpub.py
