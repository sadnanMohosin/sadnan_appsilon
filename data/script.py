def country_data(country_name):
    l1 = []
    l2 = []
    path = './file_name'
    file = glob.glob(os.path.join(path , "*.csv"))
    chunk = pd.read_csv(file, chunksize=100000, low_memory=False)
    df = pd.concat(chunk)
    l2.append(df)
    pData = df.loc[df['country'] == country_name]
    l1.append(pData)
    pFrame = pd.concat(l1, axis=0, ignore_index=True)
    pFrame.to_csv("Poland.csv")