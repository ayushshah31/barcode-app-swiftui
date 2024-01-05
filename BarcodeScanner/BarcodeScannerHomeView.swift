//
//  BarcodeScannerHomeView.swift
//  BarcodeScanner
//
//  Created by ayush on 29/12/23.
//

import SwiftUI

struct BarcodeScannerHomeView: View {
    
//    @State var barcodeScanAgain = false
    @State private var scannedBarcode = ""
    
    var body: some View {
        NavigationView{
            
            VStack{
                
                ScannerView(scannedCode: $scannedBarcode)
                    .frame(maxWidth: .infinity ,maxHeight:300)
                
//                Image(systemName: "camera.viewfinder")
//                    .resizable()
//                    .frame(width: 40, height: 40)
//                    .background(in: Circle())
//                    .onTapGesture {
//
//                    }
                
                Spacer().frame(height: 65)
                
                Label("Scanned Barcode", systemImage: "barcode.viewfinder")
                    .font(.title)
                
                
                Text(scannedBarcode.isEmpty ? "Not Yet Scanned" : scannedBarcode)
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(scannedBarcode.isEmpty ? .red : .green)
                    .padding()
                
                
            }
            .navigationTitle("Barcode Scanner")
        }
    }
}

struct BarcodeScannerHomeView_Previews: PreviewProvider {
    static var previews: some View {
        BarcodeScannerHomeView()
    }
}
