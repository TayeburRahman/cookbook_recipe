import React from "react";

export class ErrorBoundary extends React.Component {
  constructor(props) {
    super(props);
    this.state = { hasError: false, error: null };
  }

  static getDerivedStateFromError(error) {
    return { hasError: true, error };
  }

  componentDidCatch(error, info) {
    console.error("ErrorBoundary caught:", error, info);
  }

  render() {
    if (this.state.hasError) {
      return (
        <div className="bg-background text-red-500 rounded h-[calc(100vh-5rem)] flex items-center justify-center">
          <p className="font-medium">Oops! Something went wrong. Please try refreshing the page.</p>
        </div>
      );
    }
    return this.props.children;
  }
}
