import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import './index.css'
import { RouterProvider } from 'react-router-dom'
import router from './app/router/router'
import { ThemeProvider } from './theme/theme-provider'
import { Provider } from 'react-redux'
import { store } from './redux/store'
import { Toaster } from 'sonner'

createRoot(document.getElementById('root')).render(
  <StrictMode>
    <Provider store={store}>
      <div className="max-w-[1920px] mx-auto">
        <ThemeProvider defaultTheme="system" storageKey="vite-ui-theme">
          <RouterProvider router={router} />
        </ThemeProvider>
        <Toaster richColors/>
      </div>
    </Provider>
  </StrictMode>,
)
