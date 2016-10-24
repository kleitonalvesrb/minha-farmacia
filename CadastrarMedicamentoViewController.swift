//
//  CadastrarMedicamentoViewController.swift
//  Farmácia
//
//  Created by Kleiton Batista on 17/08/16.
//  Copyright © 2016 Kleiton Batista. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire
class CadastrarMedicamentoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,  AVCaptureMetadataOutputObjectsDelegate  {
    
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    
    //@IBOutlet weak var messageLabel: UILabel!
    // Added to support different barcodes
    let supportedBarCodes = [AVMetadataObjectTypeQRCode, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeUPCECode, AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeAztecCode]
    //para poder ligar e desligar o flash
    let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)


    var isPowerFlash = false
    @IBOutlet weak var btnVoltar: UIButton!
    @IBOutlet weak var btnFlash: UIButton!
    var user = Usuario.sharedInstance
    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var btnEscolherImgRemedio: UIButton!
    @IBOutlet weak var imgRemedio: UIImageView!
    @IBOutlet weak var campoCodBarras: UITextField!
    @IBOutlet weak var campoProduto: UITextField!
    @IBOutlet weak var campoPrincipioAtivo: UITextField!
    @IBOutlet weak var campoApresentacao: UITextField!
    @IBOutlet weak var campoLaboratorio: UITextField!
    @IBOutlet weak var campoClasseTerapeutica: UITextField!
    @IBOutlet weak var btnLerCodBarras: UIButton!
    @IBOutlet weak var btnSalvar: UIButton!
    
    var str:String = String()
    let i = 0
    
    var medicamento = Medicamento.medicamentoSharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        btnSalvar.layer.cornerRadius = 5
        btnLerCodBarras.layer.cornerRadius = 5
        btnEscolherImgRemedio.layer.cornerRadius = 5
        isPowerFlash = false
        self.title = "Cadastro"
       
        habilitarAcaoBotoesVoltarEflashEvisibilidade(interatividade: false, comInvisibilidade: true)
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        videoPreviewLayer?.connection.enabled = true
        captureSession?.stopRunning()
    }
    @IBAction func btnFlash(sender: AnyObject) {
        alteraImagemBotaoFlash(imagem: "flash_preenchido.png")
        if !isPowerFlash{
            isPowerFlash = true
        }else{
            isPowerFlash = false
        }
        if (device.hasTorch) {
            do {
                try device.lockForConfiguration()
                if (device.torchMode == AVCaptureTorchMode.On) {
                    alteraImagemBotaoFlash(imagem: "flash_borda.png")

                    device.torchMode = AVCaptureTorchMode.Off
                } else {
                    do {
                        try device.setTorchModeOnWithLevel(1.0)
                    } catch {
                        print(error)
                    }
                }
                device.unlockForConfiguration()
            } catch {
                print(error)
            }
        }
    }
    
    func alteraImagemBotaoFlash(imagem imgName:String){
        if let img = UIImage(named: imgName){
            btnFlash.setImage(img, forState: .Normal)
        }
    }
    /**
        Botão voltar, responsavel por retirar a os botoes de voltar e flah da tela, cancelar
     a captura de imagem
     */
    @IBAction func btnVoltar(sender: AnyObject) {
        if isPowerFlash{
            btnFlash(sender)
        }
        navigationController?.setNavigationBarHidden(navigationController?.navigationBarHidden == false, animated: true)
        retiraTabBar(false)
        apresentaBarraNavegacao(false)

        videoPreviewLayer?.hidden = true
        qrCodeFrameView?.hidden = true
        
        
        habilitarAcaoBotoesVoltarEflashEvisibilidade(interatividade: false, comInvisibilidade: true)
        desabilidaInteracaoUsuarioBotoes(interatividade: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    func apresentaBarraNavegacao(invisivel: Bool)->Void{
        self.navigationController?.navigationBar.hidden = invisivel

    }
    /**
        Método responsavel por retirar ou apresentar a tabbar
     */
    func retiraTabBar(inivisivel: Bool){
        self.tabBarController?.tabBar.hidden = inivisivel

    }
    
    @IBAction func escolherImgRemedio(sender: AnyObject) {
        escolherImg()
    }
    @IBAction func lerCodBarras(sender: AnyObject) {
       // UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        alteraImagemBotaoFlash(imagem: "flash26.png")
        desabilidaInteracaoUsuarioBotoes(interatividade: false)
        retiraTabBar(true)
        habilitarAcaoBotoesVoltarEflashEvisibilidade(interatividade: true, comInvisibilidade: false)
        apresentaBarraNavegacao(true)
        
        navigationController?.setNavigationBarHidden(navigationController?.navigationBarHidden == false, animated: true)

        lerCodigoBarras()
    }
    /**
        Método responsável por controlar a interatividade do usuario com os botos 
        ler codigo de barras e escolher foto medicamento
     */
    func desabilidaInteracaoUsuarioBotoes(interatividade interativo:Bool){
        btnEscolherImgRemedio.userInteractionEnabled = interativo
        btnLerCodBarras.userInteractionEnabled = interativo
    }
    
    /**
     
        hábilitar interação do usuario com os botoes de flash e voltar
     */
    func habilitarAcaoBotoesVoltarEflashEvisibilidade(interatividade interativo:Bool, comInvisibilidade invisibilidade:Bool){
        btnVoltar.userInteractionEnabled = interativo
        btnFlash.userInteractionEnabled = interativo
        
        btnFlash.hidden = invisibilidade
        btnVoltar.hidden = invisibilidade
        
        // tirar a tela de captura de remedio
        
        
    }
    
    /**
        preenche um novo medicamento e o adc na lista de medicamentos do usuario
     */
    @IBAction func salvar(sender: AnyObject) {
        let util = Util()
       
        medicamento.apresentacao = campoApresentacao.text
        medicamento.classeTerapeutica = campoClasseTerapeutica.text
        medicamento.codBarras = campoCodBarras.text
        medicamento.laboratorio = campoLaboratorio.text
        medicamento.nome = campoProduto.text
        medicamento.principioAtivo = campoPrincipioAtivo.text
        medicamento.fotoMedicamento = imgRemedio.image
        user.medicamento.append(medicamento)
        let dicMedicamento = ["codigoBarras":campoCodBarras.text!,
                           "nomeProduto": campoProduto.text!,
                           "principioAtivo":campoPrincipioAtivo.text!,
                           "apresentacao":campoApresentacao.text!,
                           "laboratorio":campoLaboratorio.text!,
                           "classeTerapeutica":campoClasseTerapeutica.text!,
                           "fotoMedicamentoString":util.convertImageToString(imgRemedio.image!)]
        
        
        print("--------> Pegou a Açao do botao <-------")
        
        
//        performSegueWithIdentifier("cadastrarDosagem", sender: self)
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        
//        let resultViewController = storyBoard.instantiateViewControllerWithIdentifier("dose") as! DosagemViewController
//        
//        resultViewController.medicamento = medicamento
//        
//        let navController = UINavigationController(rootViewController: resultViewController) // Creating a navigation controller with resultController at the root of the navigation stack.
//        self.presentViewController(navController, animated:true, completion: nil)
    
    }
    
    func escolherImg(){
        let alertaEscolha = UIAlertController(title: "Remédio", message: nil, preferredStyle: .ActionSheet)
        let camera = UIAlertAction(title: "Câmera", style: .Default) { (_) in
            self.definirFoto(true)
        }
        let galeria = UIAlertAction(title: "Galeria", style: .Default) { (_) in
            self.definirFoto(false)
        }
        let cancelar = UIAlertAction(title: "Cancelar", style: .Cancel) { (_) in
            print("cancelar")
            
        }
        alertaEscolha.addAction(camera)
        alertaEscolha.addAction(galeria)
        alertaEscolha.addAction(cancelar)
        self.presentViewController(alertaEscolha, animated: true, completion: nil)
    }
    /**
        #A foram de definir a foto depende da escolha#
        Irá definir a imagem correta da maneira que o usuario escolheu
    **/
    func definirFoto(camera : Bool){
        let img = UIImagePickerController()
        img.delegate = self
        /*Define a forma que a foto será selecionada, camera ou galeria*/
        if camera {
            img.sourceType = UIImagePickerControllerSourceType.Camera
        }else{
            img.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        }
        
        img.allowsEditing = false
        self.presentViewController(img, animated: true, completion: nil)
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        self.dismissViewControllerAnimated(true, completion: nil)
        imgRemedio.image = image
    }
    
    /**
        Ler código de barras
     */
    
    func lerCodigoBarras(){
        
        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video
        // as the media type parameter.
        let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Initialize the captureSession object.
            captureSession = AVCaptureSession()
            // Set the input device on the capture session.
            captureSession?.addInput(input)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
            
            // Detect all the supported bar code
            captureMetadataOutput.metadataObjectTypes = supportedBarCodes
            
            // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            
            //            videoPreviewLayer?.frame = CGRectMake(20, 20, 350 ,350)
            
            view.layer.addSublayer(videoPreviewLayer!)
            view.layer.addSublayer(btnFlash.layer)
            view.layer.addSublayer(btnVoltar.layer)
            
            
            //  let button = UIBarButtonItem(title: "Voltar", style: UIBarButtonItemStyle.Plain, target: self, action:#selector(TelaCadastroViewController.goBack))
           
            
            captureSession?.startRunning()
   
            // Initialize QR Code Frame to highlight the QR code
            qrCodeFrameView = UIView()
            view.bringSubviewToFront(qrCodeFrameView!)
            if let qrCodeFrameView = qrCodeFrameView {
                qrCodeFrameView.layer.borderColor = UIColor.greenColor().CGColor
                qrCodeFrameView.layer.borderWidth = 2
                view.addSubview(qrCodeFrameView)
                view.bringSubviewToFront(qrCodeFrameView)
            }
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
    }
  
    /**
        Método responsável por realizar a leitura do código de barras do medicamento
     */
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRectZero
           // messageLabel.text = "No barcode/QR code is detected"
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        // Here we use filter method to check if the type of metadataObj is supported
        // Instead of hardcoding the AVMetadataObjectTypeQRCode, we check if the type
        // can be found in the array of supported bar codes.
        if supportedBarCodes.contains(metadataObj.type) {
                      // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObjectForMetadataObject(metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
            
                captureSession?.stopRunning()
            

                videoPreviewLayer?.hidden = true
                qrCodeFrameView?.hidden = true
          
                campoCodBarras.text = metadataObj.stringValue

                buscarMedicamentoNet(metadataObj.stringValue)
                
                apresentaBarraNavegacao(false)
                navigationController?.setNavigationBarHidden(navigationController?.navigationBarHidden == false, animated: true)

                habilitarAcaoBotoesVoltarEflashEvisibilidade(interatividade: false, comInvisibilidade: true)
                retiraTabBar(false)

                desabilidaInteracaoUsuarioBotoes(interatividade: true)
                
            }
        }
    }
/**
        método responsavel por buscar o medicamento na base de dados e preencher os campos que serão apresentados para o usuário 
     tem como entrada o número de código de barras que recebe do método que realiza a leitura
*/
    func buscarMedicamentoNet (barCode: String) -> Void{
        
        let url = NSURL(string:"http://mobile-aceite.tcu.gov.br/mapa-da-saude/rest/remedios?codBarraEan=\(barCode)&quantidade=1")!
      
        let task = NSURLSession.sharedSession().dataTaskWithURL(url){(data, response, error) in
            if let urlContent = data{
                
                do{
                    let resultado = try NSJSONSerialization.JSONObjectWithData(urlContent, options: NSJSONReadingOptions.MutableContainers)
                    
                    
                    let res:NSArray = (resultado as! NSArray)
                    if res.count != 0 { // verifica se encontrou algo na base de dados
                    //treahd
                    
                        let qualityOfServiceClass = QOS_CLASS_BACKGROUND
                    
                        let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
                        dispatch_async(backgroundQueue, {
                            print("This is run on the background queue")
                            print("fazer aqui a validação")
                        
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                self.campoApresentacao.text = res[0]["apresentacao"] as? String
                            
                                self.campoClasseTerapeutica.text = res[0]["classeTerapeutica"] as? String
                                self.campoLaboratorio.text = res[0]["laboratorio"] as? String
                                self.campoPrincipioAtivo.text = res[0]["principioAtivo"] as? String
                                self.campoProduto.text = res[0]["produto"] as? String
                            
                            })
                        })

                    }else{//se nao encontrou nada na base de dados deve apresentar uma msg ao usuário
                        self.showAlert("Não encontrado", msg: "Produto não encontrado na base", titleBtn: "OK")
                    }
                   
                    
                }catch{
                    print("nao encontrado")
                }
            }
        }
        task.resume()
    }
    func showAlert(title: String, msg: String, titleBtn: String){
        let alerta = UIAlertController(title: title, message:msg, preferredStyle: .Alert)
        alerta.addAction(UIAlertAction(title: titleBtn, style: .Default, handler: { (action) in
            //self.dismissViewControllerAnimated(true, completion: nil)
        }))
        self.presentViewController(alerta, animated: true, completion: nil)
    }
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
