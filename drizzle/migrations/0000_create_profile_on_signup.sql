DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

INSERT INTO public.profiles (id, full_name)
SELECT u.id, left(coalesce(u.raw_user_meta_data->>'full_name', u.raw_user_meta_data->>'name', ''), 80)
FROM auth.users u
ON CONFLICT (id) DO NOTHING;

GRANT SELECT, INSERT, UPDATE ON public.profiles TO authenticated;
GRANT ALL ON public.profiles TO service_role;