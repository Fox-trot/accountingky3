﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	Если Отказ Тогда 
		Возврат
	КонецЕсли;
	
	ОбновитьПовторноИспользуемыеЗначения();
КонецПроцедуры

#КонецОбласти	

#КонецЕсли