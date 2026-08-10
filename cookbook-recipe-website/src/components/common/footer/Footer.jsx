import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { Separator } from "@/components/ui/separator"
import { Facebook, Twitter, Instagram, Linkedin, Phone, Mail, MapPin } from "lucide-react"
import Logo from '../../../assets/Logo.png';
import { Link } from "react-router-dom";
import apple from '../../../assets/apple.png'
import google from '../../../assets/google.png'
import { Form, FormField, FormItem, FormControl, FormMessage } from "@/components/ui/form";
import { useForm } from "react-hook-form";
import { z } from "zod"
import { zodResolver } from "@hookform/resolvers/zod";
import { useSendSubscribeMutation } from "@/redux/feature/legal/legalApi";
import { ErrorToast, SuccessToast } from "@/lib/utils";

const formSchema = z.object({
  email: z.string().email(),
})

const Footer = () => {

  const form = useForm({
    resolver: zodResolver(formSchema),
    defaultValues: {
      email: '',
    },
  })

  const [sendSubscribe, { isLoading }] = useSendSubscribeMutation()

  const onSubmit = async (data) => {
    try {
      await sendSubscribe(data)
      SuccessToast("Subscribe successfully")
      form.reset()
    } catch (error) {
      console.log(error)
      ErrorToast("Subscribe failed")
    }
  }

  return (
    <footer className="bg-gradient-to-b from-secondary to-secondary/50 text-foreground">
      {/* Newsletter Section */}
      <div className="px-4 py-8 md:px-8 lg:px-16">
        <div className="mx-auto container max-w-7xl">
          <div className="flex flex-col items-center justify-center space-y-4 text-center md:flex-row md:justify-between md:space-x-4 md:space-y-0">
            <div className="flex flex-1 w-full max-w-md">
              <h3 className="text-xl md:text-2xl lg:text-4xl font-medium text-foreground font-caladea">Subscribe to our Newsletter</h3>
            </div>
            <Form {...form}>
              <form onSubmit={form.handleSubmit(onSubmit)} className="flex flex-1 w-full max-w-md space-x-2">
                <FormField
                  control={form.control}
                  name="email"
                  render={({ field }) => (
                    <FormItem>
                      <FormControl>
                        <Input placeholder="Enter your email" {...field} />
                      </FormControl>
                      <FormMessage />
                    </FormItem>
                  )}
                />
                <Button loading={isLoading} type="submit">Subscribe</Button>
              </form>
            </Form>
          </div>
        </div>
      </div>

      <Separator />

      {/* Main Footer Content */}
      <div className="px-4 py-12 md:px-8 lg:px-16 xl:px-0">
        <div className="mx-auto container max-w-7xl">
          <div className="grid gap-8 md:grid-cols-2 lg:grid-cols-4">
            {/* Brand & Social */}
            <div className="space-y-4 flex flex-col">
              <img src={Logo} alt="" className="h-16 w-16 rounded-full object-contain dark:brightness-150" />
              <p className="text-sm text-foreground">Find Us On</p>
              <div className="flex space-x-3">
                <Button
                  variant="outline"
                  size="icon"
                  className="rounded-full border-muted-foreground bg-inherit"
                >
                  <Facebook />
                </Button>
                <Button
                  variant="outline"
                  size="icon"
                  className="rounded-full border-muted-foreground bg-inherit"
                >
                  <Twitter />
                </Button>
                <Button
                  variant="outline"
                  size="icon"
                  className="rounded-full border-muted-foreground bg-inherit"
                >
                  <Instagram />
                </Button>
                <Button
                  variant="outline"
                  size="icon"
                  className="rounded-full border-muted-foreground bg-inherit"
                >
                  <Linkedin />
                </Button>
              </div>
            </div>

            {/* Contact Info */}
            <div className="space-y-4">
              <h4 className="text-lg font-semibold text-foreground">Contact Info</h4>
              <div className="space-y-3">
                <div className="flex items-center space-x-3">
                  <Phone className="h-4 w-4 text-foreground" />
                  <span className="text-sm text-foreground">+60 3-4567 8901</span>
                </div>
                <div className="flex items-center space-x-3">
                  <Mail className="h-4 w-4 text-foreground" />
                  <span className="text-sm text-foreground">hello@blueoak.edu.my</span>
                </div>
                <div className="flex items-start space-x-3">
                  <MapPin className="h-4 w-4 text-foreground mt-0.5" />
                  <span className="text-sm text-foreground">
                    Jalan Damansara, Kuala Lumpur,
                    <br />
                    Malaysia
                  </span>
                </div>
              </div>
            </div>

            {/* About & Legal */}
            <div className="space-y-4">
              <h4 className="text-lg font-semibold text-foreground">About & Legal</h4>
              <div className="space-y-2">
                <Link to="/about" className="block text-sm text-foreground transition-colors hover:text-muted-foreground">
                  About Us
                </Link>
                <Link to="/legal/terms" className="block text-sm text-foreground transition-colors hover:text-muted-foreground">
                  Terms & Conditions
                </Link>
                <Link to="/legal/privacy" className="block text-sm text-foreground transition-colors hover:text-muted-foreground">
                  Privacy Policy
                </Link>
              </div>
            </div>

            {/* Help & Support */}
            <div className="space-y-4">
              <h4 className="text-lg font-semibold text-foreground">Help & Support</h4>
              <div className="space-y-2">
                <Link to="/contact" className="block text-sm text-foreground transition-colors hover:text-muted-foreground">
                  Contact Us
                </Link>
                <Link to="/legal/help" className="block text-sm text-foreground transition-colors hover:text-muted-foreground">
                  Help Center
                </Link>
                <Link to="/legal/faq" className="block text-sm text-foreground transition-colors hover:text-muted-foreground">
                  FAQs
                </Link>
              </div>
            </div>
          </div>
        </div>
      </div>

      <Separator />

      {/* App Download Section */}
      <div className="px-4 py-8 md:px-8 lg:px-16">
        <div className="mx-auto max-w-7xl">
          <div className="text-center">
            <h4 className="text-lg font-semibold text-foreground">Download our App from</h4>
            <div className="flex flex-col items-center justify-center space-y-3 sm:flex-row sm:space-x-4 sm:space-y-0">
              <div id="app-store" className="flex flex-col sm:flex-row items-center gap-6 mt-6">
                <a href="#" aria-label="Download on the App Store" className="transform hover:scale-105 transition-transform duration-300">
                  <img src={apple} alt="Download on the App Store" className="h-10 w-auto" />
                </a>
                <a href="#" aria-label="Get it on Google Play" className="transform hover:scale-105 transition-transform duration-300">
                  <img src={google} alt="Get it on Google Play" className="h-10 w-auto" />
                </a>
              </div>
            </div>
          </div>
        </div>
      </div>

      <Separator />

      {/* Copyright */}
      <div className="px-4 py-6 md:px-8 lg:px-16">
        <div className="mx-auto max-w-7xl">
          <p className="text-center text-sm text-foreground">© 2025 Cookbook Recipe. All rights reserved.</p>
        </div>
      </div>
    </footer>
  )
}

export default Footer;