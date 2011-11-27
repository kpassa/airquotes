# -*- coding: utf-8 -*-
class SessionsController < ApplicationController
  def new
  end

  def create
    u = User.find_by_username(params[:username])
    if u && u.authenticate(params[:password])
      session[:user_id] = u.id
      redirect_to_target_or_default( root_url, notice: "Ha entrado al sistema!" )
    else
      flash.now.alert =  "Usuario o contraseña incorrecta"
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_url, :notices => "Ha salido del sistema."
  end

end

