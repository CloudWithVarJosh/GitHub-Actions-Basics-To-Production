
import { render, screen } from "@testing-library/react";
import { describe, it, expect, vi } from "vitest";
import App from "./App";

describe("App", () => {
  it("renders the User Management heading", () => {
    vi.stubGlobal(
      "fetch",
      vi.fn().mockResolvedValue({
        ok: true,
        json: async () => []
      })
    );

    render(<App />);

    expect(
      screen.getByRole("heading", { name: /user management/i })
    ).toBeInTheDocument();

    vi.unstubAllGlobals();
  });
});
