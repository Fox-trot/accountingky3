﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("ВидОтчета", ПредопределенноеЗначение("Перечисление.ВидыРегламентированныхОтчетов.Баланс"));
	ОткрытьФорму("Документ.РегламентированныйОтчет.Форма.ФормаСписка", 
		ПараметрыФормы, 
		ПараметрыВыполненияКоманды.Источник, 
		"РегламентированныйОтчетБаланс", 
		ПараметрыВыполненияКоманды.Окно, 
		ПараметрыВыполненияКоманды.НавигационнаяСсылка);
КонецПроцедуры

#КонецОбласти
